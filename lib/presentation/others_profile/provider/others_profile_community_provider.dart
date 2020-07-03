import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_detail.dart';

class OthersProfileCommunityProvider with ChangeNotifier {
  final _repository = Repository();

  List<CommunityDetail> _communityList = [];
  List<CommunityDetail> get communityList => _communityList;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;
  int get pageRequest => _pageRequest;

  StreamController<otherCommunityState> _streamController =
      StreamController<otherCommunityState>.broadcast();
  Stream<otherCommunityState> get communityStreamData =>
      _streamController.stream;

  Future<Null> getOtherCommunityList(
      {String userId, bool isRefresh = true}) async {
    if (isRefresh) {
      _canLoadMore = true;
      _pageRequest = 1;
      _communityList.clear();
    }
    _streamController.add(otherCommunityState.loading);
    final response = await _repository.getOtherCommunityList(
      userId: userId,
      pageRequest: _pageRequest,
    );
    if (response != null && response.total > 0) {
      _communityList.addAll(response.communityDetailList);
      _canLoadMore = response.total > _communityList.length;
      _pageRequest += 1;
      _streamController.add(otherCommunityState.success);
    } else {
      _streamController.add(otherCommunityState.empty);
      _canLoadMore = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

enum otherCommunityState { loading, success, empty }
