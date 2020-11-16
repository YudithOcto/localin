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

  bool _isMounted = true;
  final Debounce _debounce = Debounce(milliseconds: 300);

  List<CommunityDetail> _communityDetailList = [];

  List<CommunityDetail> get resultCommunityList => _communityDetailList;

  searchCommunity(String value) {
    if (value.isNotEmpty) {
      _debounce.run(() => getSearchResult(isRefresh: true, keyword: value));
    } else {
      _debounce.cancel();
      _offset = 1;
      _communityDetailList.clear();
      _isCanLoadMore = true;
      notifyListeners();
    }
  }

  Future<Null> getSearchResult(
      {bool isRefresh = false, String keyword = ''}) async {
    if (isRefresh) {
      _isCanLoadMore = true;
      _communityDetailList.clear();
      _offset = 1;
    }

    setState(searchCommunityState.loading);
    final result = await _repository.getCommunityList(
        keyword: keyword, page: _offset, limit: _limit);
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
    super.dispose();
  }
}

enum searchCommunityState { loading, success, empty }
