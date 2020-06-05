import 'dart:async';
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
  String communitySlug;
  bool isSearchMemberPage = false;
  bool sendCommentLoading = false;
  Repository _repository = Repository();
  File attachmentFileImage, attachmentFileVideo;
  TextEditingController commentController = TextEditingController();

  CommunityDetailProvider({this.communitySlug}) {
    getCommunityDetail(communitySlug);
  }

  @override
  void dispose() {
    commentController.dispose();
    _detailState.close();
    super.dispose();
  }

  void setSearchMemberPage(bool value) {
    this.isSearchMemberPage = value;
    notifyListeners();
  }

  void setSentCommentLoading(bool value) {
    this.sendCommentLoading = value;
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
    setSentCommentLoading(true);
    final response = await _repository.joinCommunity(communityId);
    if (response != null && response.error == null) {
      communityDetail.isJoin = true;
      notifyListeners();
    }
    setSentCommentLoading(true);
    return response;
  }

  final StreamController<communityDetailState> _detailState =
      StreamController<communityDetailState>.broadcast();
  Stream<communityDetailState> get streamDetailState => _detailState.stream;

  Future<Null> getCommunityDetail(String communityId) async {
    _detailState.add(communityDetailState.loading);
    final response = await _repository.getCommunityDetail(communityId);
    if (response.error == null) {
      _detailState.add(communityDetailState.success);
      communityDetail = response.detailCommunity;
    } else {
      _detailState.add(communityDetailState.empty);
    }
  }

  Future<CommunityCommentBaseResponse> postComment() async {
    setSentCommentLoading(true);
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
    final response =
        await _repository.postComment(communityDetail.id, formData);
    if (response.message != null) {
      commentController.clear();
      attachmentFileVideo = null;
      attachmentFileImage = null;
      notifyListeners();
    }
    setSentCommentLoading(false);
    return response;
  }
}

enum communityDetailState { loading, success, empty }
