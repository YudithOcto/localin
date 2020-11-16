import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/provider/base_model_provider.dart';

class CommunityDetailProvider extends BaseModelProvider {
  CommunityDetail communityDetail;
  String communitySlug;
  bool isSearchMemberPage = false;
  bool sendCommentLoading = false;
  Repository _repository = Repository();
  File attachmentFileImage, attachmentFileVideo;
  TextEditingController commentController = TextEditingController();

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

  Future<CommunityJoinResponse> joinCommunity(String communityId) async {
    setSentCommentLoading(true);
    final response = await _repository.joinCommunity(communityId);
    if (response.error == null) communityDetail.joinStatus = 'Waiting';
    setSentCommentLoading(true);
    return response;
  }

  final StreamController<communityDetailState> _detailState =
      StreamController<communityDetailState>.broadcast();

  Stream<communityDetailState> get streamDetailState => _detailState.stream;

  Future<Null> getCommunityDetail(String communitySlug) async {
    _detailState.add(communityDetailState.loading);
    final response = await _repository.getCommunityDetail(communitySlug);
    if (response.error == null) {
      _detailState.add(communityDetailState.success);
      communityDetail = response.detailCommunity;
      notifyListeners();
    } else {
      _detailState.add(communityDetailState.empty);
    }
  }

  Future<bool> getAdmin({@required String communityId}) async {
    final response =
        await _repository.getCommunityMember(communityId, 1, 10, 'admin');
    if (response.error == null) {
      return response.data.length > 1;
    }
    return false;
  }

  Future<CommunityDetailBaseResponse> leaveCommunity(String commId) async {
    final response = await _repository.leaveCommunity(commId);
    return response;
  }

  Future<CommunityCommentBaseResponse> postComment() async {
    setSentCommentLoading(true);
    String type = attachmentFileImage != null
        ? 'image'
        : attachmentFileVideo != null
            ? 'video'
            : null;
    String attachmentFilePath = attachmentFileImage != null
        ? attachmentFileImage.path
        : attachmentFileVideo != null
            ? attachmentFileVideo.path
            : '';
    FormData formData = FormData.fromMap(
      {
        'komentar': commentController.text,
        'tipe': type,
        'lampiran': attachmentFilePath.isEmpty
            ? null
            : MultipartFile.fromFileSync(
                attachmentFilePath,
                filename: '$attachmentFilePath',
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
