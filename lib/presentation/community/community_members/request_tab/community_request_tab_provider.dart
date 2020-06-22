import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_member_detail.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';

class CommunityRequestTabProvider with ChangeNotifier {
  final _repository = Repository();
  String _communityId = '';

  CommunityRequestTabProvider({String communityId}) {
    _communityId = communityId;
  }

  List<CommunityMemberDetail> _requestList = List();
  List<CommunityMemberDetail> get requestList => _requestList;

  bool _canLoadMore = true;
  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;
  int get currentPageRequest => _pageRequest;

  final _streamController = StreamController<communityMemberState>.broadcast();
  Stream<communityMemberState> get requestStream => _streamController.stream;

  bool _isMounted = true;

  Future<Null> getRequestList({bool isRefresh = true}) async {
    if (isRefresh) {
      _pageRequest = 1;
      _requestList.clear();
      _canLoadMore = true;
    }

    final response = await _repository.getCommunityMember(
        _communityId, _pageRequest, 10, 'request');
    if (response.error == null &&
        (response.data.isNotEmpty || _requestList.isNotEmpty)) {
      _requestList.addAll(response.data);
      _canLoadMore = response.total > _requestList.length;
      _pageRequest += 1;
      setState(communityMemberState.success);
    } else {
      _canLoadMore = false;
      setState(_requestList.isEmpty
          ? communityMemberState.success
          : communityMemberState.success);
    }
    notifyListeners();
  }

  Future<CommunityMemberResponse> moderateSingleMember(
      {String status, String memberId}) async {
    final response =
        await _repository.moderateSingleMember(_communityId, memberId, status);
    return response;
  }

  Future<CommunityMemberResponse> moderateAllMember({String status}) async {
    final response = await _repository.moderateMember(_communityId, status);
    return response;
  }

  setState(communityMemberState state) {
    if (_isMounted) {
      _streamController.add(state);
    }
  }

  List<String> _sortingList = [
    'Suggested First',
    'Newest First',
    'Oldest First',
    'User Verified',
    'User Unverified'
  ];
  List<String> get sortingList => _sortingList;

  String _selectedSort = 'Suggested First';
  String get selectedSort => _selectedSort;
  set selectSort(String value) {
    _selectedSort = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _isMounted = false;
    _streamController.close();
    super.dispose();
  }
}
