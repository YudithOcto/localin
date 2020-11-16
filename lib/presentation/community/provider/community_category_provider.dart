import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_detail.dart';

class CommunityCategoryProvider with ChangeNotifier {
  final _repository = Repository();

  final _otherCommunityStream =
      StreamController<othersCommunityState>.broadcast();

  Stream<othersCommunityState> get streamOther => _otherCommunityStream.stream;

  int _page = 1;

  int get page => _page;

  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  List<CommunityDetail> _otherCommunity = [];

  List<CommunityDetail> get otherCommunity => _otherCommunity;

  Future<Null> getCommunityByCategory(
      {bool isRefresh = true, String categoryId}) async {
    if (isRefresh) {
      _page = 1;
      _canLoadMore = true;
      _otherCommunity.clear();
    }

    final result = await _repository.getCommunityListByCategory(categoryId);
    if (result.error == null) {
      _otherCommunity.addAll(result.communityDetailList);
      _otherCommunityStream.add(othersCommunityState.success);
      _canLoadMore = result.total > _otherCommunity.length;
      _page += 1;
    } else {
      _canLoadMore = false;
      _otherCommunityStream.add(_otherCommunity.isEmpty
          ? othersCommunityState.empty
          : othersCommunityState.success);
    }
    notifyListeners();
  }

  final _popularCommunityStream =
      StreamController<popularCommunityState>.broadcast();

  Stream<popularCommunityState> get streamPopular =>
      _popularCommunityStream.stream;

  List<CommunityDetail> _popularCommunity = [];

  List<CommunityDetail> get popularCommunity => _popularCommunity;

  Future<Null> getPopularCommunity({String categoryId}) async {
    final result = await _repository.getPopularCommunity(
        limit: 6, offset: 1, categoryId: categoryId);
    if (result.error == null) {
      _popularCommunity.addAll(result.communityDetailList);
      _popularCommunityStream.add(popularCommunityState.success);
    } else {
      _popularCommunityStream.add(popularCommunityState.empty);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _otherCommunityStream.close();
    _popularCommunityStream.close();
    super.dispose();
  }
}

enum othersCommunityState { loading, success, empty }
enum popularCommunityState { loading, success, empty }
