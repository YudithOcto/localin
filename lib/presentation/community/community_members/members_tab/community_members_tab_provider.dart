import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_member_detail.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';

class CommunityMembersTabProvider with ChangeNotifier {
  final _repository = Repository();
  String _communityId = '';

  CommunityMembersTabProvider({String communityId}) {
    _communityId = communityId;
  }

  List<CommunityMemberDetail> _memberList = List();
  List<CommunityMemberDetail> get memberList => _memberList;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;
  int get currentPageRequest => _pageRequest;

  final _streamController = StreamController<communityMemberState>.broadcast();
  Stream<communityMemberState> get memberStream => _streamController.stream;

  bool _isMounted = true;

  Future<Null> getMembersCommunity(
      {bool isRefresh = true, String keyword}) async {
    setState(communityMemberState.loading);
    if (isRefresh) {
      _pageRequest = 1;
      _memberList.clear();
      _canLoadMore = true;
    }

    final response = await _repository.getCommunityMember(
        _communityId, _pageRequest, 10, 'member',
        search: keyword);
    if (response.error == null &&
        (_memberList.isNotEmpty || response.data.isNotEmpty)) {
      _memberList.addAll(response.data);
      _canLoadMore = response.total > _memberList.length;
      _pageRequest += 1;
      setState(communityMemberState.success);
    } else {
      _canLoadMore = false;
      setState(_memberList.isEmpty
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
