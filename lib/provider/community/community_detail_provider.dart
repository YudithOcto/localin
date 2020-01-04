import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/helper_permission.dart';

class CommunityDetailProvider extends BaseModelProvider {
  CommunityDetail communityDetail;
  bool isSearchMemberPage = false;
  Repository _repository = Repository();
  HelperPermission _permissionHelper = HelperPermission();
  CommunityDetailProvider({this.communityDetail});
  File attachmentFileImage, attachmentFileVideo;
  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

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
      attachmentFileImage = result;
      notifyListeners();
      return null;
    }
    return 'You need to grant permission for storage';
  }

  Future<String> getVideoFromStorage() async {
    var result = await _permissionHelper.openVideoStorage();
    if (result != null) {
      attachmentFileVideo = result;
      notifyListeners();
      return null;
    }
    return 'You need to grant permission for storage';
  }

  Future<CommunityCommentBaseResponse> postComment() async {
    String type = attachmentFileImage != null
        ? 'image'
        : attachmentFileVideo != null ? 'video' : null;
    String attachmentFilePath = attachmentFileImage != null
        ? attachmentFileImage.path
        : attachmentFileVideo != null ? attachmentFileVideo.path : '';
    FormData formData = FormData.fromMap(
      {
        'komentar': commentController.text,
        'tipe': type,
        'lampiran': attachmentFilePath.isEmpty
            ? null
            : MultipartFile.fromFileSync(
                attachmentFilePath,
                filename: '$attachmentFilePath}',
              ),
      },
    );
    var response = await _repository.postComment(communityDetail.id, formData);
    if (response.message != null) {
      commentController.clear();
      attachmentFileVideo = null;
      attachmentFileImage = null;
      notifyListeners();
    }
    return response;
  }
}
