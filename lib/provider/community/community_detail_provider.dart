import 'dart:io';

import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/helper_permission.dart';
import 'package:permission_handler/permission_handler.dart';

class CommunityDetailProvider extends BaseModelProvider {
  CommunityDetail communityDetail;
  bool isSearchMemberPage = false;
  Repository _repository = Repository();
  HelperPermission _permissionHelper = HelperPermission();
  CommunityDetailProvider({this.communityDetail});
  File attachmentFile;

  void setSearchMemberPage(bool value) {
    this.isSearchMemberPage = value;
    notifyListeners();
  }

  Future<CommunityMemberResponse> approveMember(
      String communityId, String memberId) async {
    setState(ViewState.Busy);
    var response = await _repository.approveMember(communityId, memberId);
    if (response != null) setState(ViewState.Idle);
    return response;
  }

  Future<CommunityJoinResponse> joinCommunity(String communityId) async {
    final response = await _repository.joinCommunity(communityId);
    if (response != null && response.error == null) {
      communityDetail.isJoin = true;
      notifyListeners();
    }
    return response;
  }

  Future<CommunityCommentBaseResponse> getCommentList(
      String communityId) async {
    final response = await _repository.getCommunityCommentList(communityId);
    return response;
  }

  Future<String> getImageFromStorage() async {
    var result = await _permissionHelper.openGallery();
    if (result != null) {
      attachmentFile = result;
      return '';
    }
    return 'You need to grant permission for storage';
  }

  Future<String> getVideoFromStorage() async {
    var result = await _permissionHelper.openVideoStorage();
    if (result != null) {
      attachmentFile = result;
      return '';
    }
    return 'You need to grant permission for storage';
  }
}
