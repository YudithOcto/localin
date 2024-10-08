import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/user/user_model.dart';

class CommentProvider with ChangeNotifier {
  final Repository _repository = Repository();
  final commentController = TextEditingController();

  bool _isTextEmpty = false;

  bool get isTextEmpty => _isTextEmpty;

  set textIsEmpty(bool value) {
    _isTextEmpty = value;
    notifyListeners();
  }

  List<bool> showReplay = [];

  bool _isCanLoadMoreComment = true;

  bool get isCanLoadMoreComment => _isCanLoadMoreComment;

  int _commentRequestOffset = 1;
  int _pageLimit = 10;

  int get commentRequestOffset => _commentRequestOffset;

  final ArticleDetail _currentArticleModel;
  final UserModel _userProfile;

  final StreamController<commentState> _streamController =
      StreamController<commentState>.broadcast();

  Stream<commentState> get state => _streamController.stream;
  bool _isMounted = true;

  CommentProvider({ArticleDetail articleDetail, UserModel profile})
      : assert(articleDetail != null, profile != null),
        _currentArticleModel = articleDetail,
        _userProfile = profile;

  List<ArticleCommentDetail> _articleComments = [];

  List<ArticleCommentDetail> get articleCommentList => _articleComments;

  Future<Null> getCommentList(String articleId, {bool isRefresh = true}) async {
    setState(commentState.loading);
    if (isRefresh) {
      _commentRequestOffset = 1;
      _articleComments.clear();
      _isCanLoadMoreComment = true;
    }
    final response = await _repository.getArticleComment(articleId,
        offset: _commentRequestOffset, limit: _pageLimit);
    if (response != null && !response.error) {
      _articleComments.addAll(response.comments);
      _commentRequestOffset += 1;
      _isCanLoadMoreComment = response.total > _articleComments.length;
      setState(commentState.success);
      notifyListeners();
    } else {
      _isCanLoadMoreComment = false;
      setState(_articleComments.isNotEmpty
          ? commentState.success
          : commentState.empty);
    }
  }

  /// Publish Comment
  final FocusNode _focusNode = FocusNode();

  FocusNode get messageFocusNode => _focusNode;

  ArticleCommentDetail _commentReplayClicked;

  ArticleCommentDetail get commentClickedItem => _commentReplayClicked;

  void setReplyToOtherUserCommentModel(ArticleCommentDetail value,
      {bool isNeedRequestFocus = true}) {
    if (isNeedRequestFocus) {
      _focusNode.requestFocus(FocusNode());
    }
    _commentReplayClicked = value;
    notifyListeners();
  }

  Future<String> publishComment() async {
    final response = await _repository.publishArticleComment(
        _currentArticleModel.id, commentController.text);
    if (response != null && !response.error) {
      response.postCommentResult.senderAvatar = _userProfile.imageProfile;
      response.postCommentResult.sender = _userProfile.username;
      _articleComments.add(response.postCommentResult);
    }
    commentController.clear();
    notifyListeners();
    return response.message;
  }

  ///Replay Comment
  Future<String> replyOthersComment() async {
    final response = await _repository.replyOthersComment(
        _commentReplayClicked.parentId ?? _commentReplayClicked.commentId,
        '${_commentReplayClicked.sender.split(' ')[0]} ${commentController.text}');
    if (response != null && !response.error) {
      response.postCommentResult.senderAvatar = _userProfile.imageProfile;
      response.postCommentResult.sender = _userProfile.username;
      if (_commentReplayClicked.parentId != null) {
        _articleComments
            .where((e) => e.commentId == response.postCommentResult.parentId)
            .map((e) => e.replay.add(response.postCommentResult))
            .toList();
      } else {
        _articleComments
            .where((e) => e.commentId == _commentReplayClicked.commentId)
            .map((e) => e.replay.add(response.postCommentResult))
            .toList();
      }
    }
    commentController.clear();
    notifyListeners();
    return response.message;
  }

  void demo() {
    ArticleCommentDetail articleCommentDetail = ArticleCommentDetail(
      sender: 'me bitch',
      senderAvatar:
          'https://akcdn.detik.net.id/community/media/visual/2020/02/02/db286298-4301-4c22-acc1-687cac9acd59_169.jpeg?w=700&q=80',
      commentId: 'lasd2131pok',
      comment: commentController.text,
      createdAt: '2020-05-13 15:12:30',
      replay: [],
    );
    final response = Future.delayed(Duration(seconds: 2), () {
      return ArticleCommentBaseResponse(
          postCommentResult: articleCommentDetail,
          message: 'success pak',
          error: false);
    });
  }

  setState(commentState state) {
    if (_isMounted) {
      _streamController.add(state);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    commentController.dispose();
    _streamController.close();
    _isMounted = false;
    super.dispose();
  }
}

enum commentState { loading, success, empty }
