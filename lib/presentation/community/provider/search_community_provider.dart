import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/utils/debounce.dart';

class SearchCommunityProvider with ChangeNotifier {
  final StreamController<searchCommunityState> _searchController =
      StreamController<searchCommunityState>.broadcast();
  Stream<searchCommunityState> get streamSearch => _searchController.stream;

  bool _isCanLoadMore = false;
  bool get isCanLoadMore => _isCanLoadMore;

  int _offset = 1;
  int get offset => _offset;
  int _limit = 10;

  final Repository _repository = Repository();

  final TextEditingController _searchTextController = TextEditingController();
  TextEditingController get searchTextController => _searchTextController;

  bool _isMounted = true;
  final Debounce _debounce = Debounce(milliseconds: 300);

  List<CommunityDetail> _communityDetailList = [];
  List<CommunityDetail> get resultCommunityList => _communityDetailList;

  SearchCommunityProvider() {
    _searchTextController.addListener(_searchCommunity);
  }

  _searchCommunity() {
    if (_searchTextController.text.isNotEmpty) {
      _debounce.run(() => getSearchResult(isRefresh: true));
    } else {
      _debounce.cancel();
      _offset = 1;
      _communityDetailList.clear();
      _isCanLoadMore = true;
      notifyListeners();
    }
  }

  Future<Null> getSearchResult({bool isRefresh = false}) async {
    if (isRefresh) {
      _isCanLoadMore = true;
      _communityDetailList.clear();
      _offset = 1;
    }

    setState(searchCommunityState.loading);
    final result = await _repository.getCommunityList(
        keyword: _searchTextController.text, page: _offset, limit: _limit);
    if (result.error == null && result.total > 0) {
      setState(searchCommunityState.success);
      _communityDetailList.addAll(result.communityDetailList);
      _isCanLoadMore = result.total > _communityDetailList.length;
      _offset += 1;
    } else {
      _isCanLoadMore = false;
      setState(searchCommunityState.empty);
    }
  }

  setState(searchCommunityState state) {
    if (_isMounted) {
      _searchController.add(state);
    }
  }

  @override
  void dispose() {
    _searchController.close();
    _isMounted = false;
    _searchTextController.removeListener(_searchCommunity);
    _searchTextController.dispose();
    super.dispose();
  }
}

enum searchCommunityState { loading, success, empty }
