import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_member_detail.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';

class CommunityBlockedTabProvider with ChangeNotifier {
  final _repository = Repository();
  String _communityId = '';

  CommunityBlockedTabProvider({String communityId}) {
    _communityId = communityId;
  }

  List<CommunityMemberDetail> _blockedList = List();
  List<CommunityMemberDetail> get blockedList => _blockedList;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;
  int get currentPageRequest => _pageRequest;

  final _streamController = StreamController<communityMemberState>.broadcast();
  Stream<communityMemberState> get blockedStream => _streamController.stream;

  bool _isMounted = true;

  String _userSearch = '';
  set requestSearchKeyword(String value) {
    _userSearch = value;
    getBlockedUser(isRefresh: true);
  }

  Future<Null> getBlockedUser({bool isRefresh = true}) async {
    if (isRefresh) {
      _pageRequest = 1;
      _blockedList.clear();
      _canLoadMore = true;
    }
    setState(communityMemberState.loading);
    final response = await _repository.getCommunityMember(
        _communityId, _pageRequest, 10, 'blocked',
        search: _userSearch);
    if (response.error == null &&
        (response.data.isNotEmpty || _blockedList.isNotEmpty)) {
      _blockedList.addAll(response.data);
      _canLoadMore = response.total > _blockedList.length;
      _pageRequest += 1;
      setState(communityMemberState.success);
    } else {
      _canLoadMore = false;
      setState(_blockedList.isEmpty
          ? communityMemberState.empty
          : communityMemberState.success);
    }
    notifyListeners();
  }

  setState(communityMemberState state) {
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
