import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_member_detail.dart';
import 'package:localin/presentation/community/community_members/shared_members_widget/enum_members.dart';

class CommunityAdminTabProvider with ChangeNotifier {
  final _repository = Repository();
  String _communityId = '';
  bool _isAdmin = true;

  bool get isAdmin => _isAdmin;

  CommunityAdminTabProvider({String communityId, bool isAdmin}) {
    _communityId = communityId;
    _isAdmin = isAdmin;
  }

  List<CommunityMemberDetail> _adminList = List();

  List<CommunityMemberDetail> get adminList => _adminList;

  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  int _pageRequest = 1;

  int get currentPageRequest => _pageRequest;

  final _streamController = StreamController<communityMemberState>.broadcast();

  Stream<communityMemberState> get adminStream => _streamController.stream;

  bool _isMounted = true;

  String _userSearch = '';

  set requestSearchKeyword(String value) {
    _userSearch = value;
    getAdminCommunity(isRefresh: true);
  }

  Future<Null> getAdminCommunity({bool isRefresh = true}) async {
    if (isRefresh) {
      _pageRequest = 1;
      _adminList.clear();
      _canLoadMore = true;
    }
    setState(communityMemberState.loading);
    final response = await _repository.getCommunityMember(
        _communityId, _pageRequest, 10, 'admin',
        search: _userSearch);
    if (response.error == null &&
        (_adminList.isNotEmpty || response.data.isNotEmpty)) {
      _adminList.addAll(response.data);
      _canLoadMore = response.total > _adminList.length;
      _pageRequest += 1;
      setState(communityMemberState.success);
    } else {
      _canLoadMore = false;
      setState(_adminList.isEmpty
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
