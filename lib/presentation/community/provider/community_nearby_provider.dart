import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_join_response.dart';

class CommunityNearbyProvider with ChangeNotifier {
  bool _isMounted = true;
  final _repository = Repository();

  final _streamController = StreamController<communityNearbyState>.broadcast();
  Stream<communityNearbyState> get communityStream => _streamController.stream;

  int _offset = 1;
  int get offset => _offset;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  List<CommunityDetail> _communityNearbyList = [];
  List<CommunityDetail> get communityNearbyList => _communityNearbyList;

  Future<Null> getNearbyCommunity({bool isRefresh = true}) async {
    setState(communityNearbyState.loading);
    if (isRefresh) {
      _offset = 1;
      _canLoadMore = true;
      _communityNearbyList.clear();
    }

    final response = await _repository.getCommunityList();
    if (response.error == null) {
      setState(communityNearbyState.success);
      _communityNearbyList.addAll(response.communityDetailList);
      _offset += 1;
      _canLoadMore = response.total > _communityNearbyList.length;
    } else {
      _canLoadMore = false;
      setState(_communityNearbyList.isEmpty
          ? communityNearbyState.empty
          : communityNearbyState.success);
    }
  }

  Future<CommunityJoinResponse> joinCommunity(String communityId) async {
    final response = await _repository.joinCommunity(communityId);
    if (response.error == null) {
      getNearbyCommunity(isRefresh: true);
    }
    return response;
  }

  setState(communityNearbyState state) {
    if (_isMounted) {
      _streamController.add(state);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _streamController.close();
    super.dispose();
  }
}

enum communityNearbyState { loading, success, empty }
