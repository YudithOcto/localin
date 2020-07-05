import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_comment_base_response.dart';

class CommunityPublishCommentProvider with ChangeNotifier {
  final _repository = Repository();

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  final commentTextController = TextEditingController();

  bool _isTextEmpty = true;
  bool get isTextEmpty => _isTextEmpty;
  set emptyText(bool value) {
    _isTextEmpty = value;
    notifyListeners();
  }

  final FocusNode _focusNode = FocusNode();
  FocusNode get formFocusNode => _focusNode;

  CommunityComment _currentClickedReplyCommentData;
  CommunityComment get currentClickedReplyData =>
      _currentClickedReplyCommentData;

  void setReplyOthersCommentData(CommunityComment value,
      {bool needFocus = true}) {
    if (needFocus) {
      _focusNode.requestFocus(FocusNode());
    } else {
      _focusNode.unfocus();
    }
    _currentClickedReplyCommentData = value;
    notifyListeners();
  }

  Future<CommunityCommentBaseResponse> publishComment(
      String communityId) async {
    Map<String, dynamic> map = Map();
    if (_currentClickedReplyCommentData != null) {
      map['parent_id'] = _currentClickedReplyCommentData.parentId == 'null'
          ? _currentClickedReplyCommentData.id
          : _currentClickedReplyCommentData.parentId;
      map['komentar'] =
          '${_currentClickedReplyCommentData.createdName.split(' ')[0]} ${commentTextController.text}';
    } else {
      map['komentar'] = commentTextController.text;
    }
    final _form = FormData.fromMap(map);
    final response = await _repository.postComment(communityId, _form);
    commentTextController.clear();
    return response;
  }
}
