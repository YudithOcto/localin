import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/community/community_comment_base_response.dart';

class CommunityRetrieveCommentProvider with ChangeNotifier {
  final _repository = Repository();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  final _streamController = StreamController<communityCommentState>.broadcast();

  Stream<communityCommentState> get commentListState =>
      _streamController.stream;

  int _page = 1;

  int get page => _page;

  bool _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  List<CommunityComment> _commentList = [];

  List<CommunityComment> get commentList => _commentList;

  Map<int, bool> _childComment = Map();

  Map<int, bool> get childComment => _childComment;

  void setChildCommentDisplay(bool value, int commentId) {
    final isHaveChildComment = _childComment.containsKey(commentId);
    if (isHaveChildComment) {
      _childComment.update(commentId, (v) => value);
    } else {
      _childComment.putIfAbsent(commentId, () => true);
    }
    notifyListeners();
  }

  bool isShowChildComment(int commentId) {
    final isHaveChildComment = _childComment.containsKey(commentId);
    if (isHaveChildComment) {
      return _childComment[commentId];
    }
    return false;
  }

  Future<Null> getCommentList(
      {String communityId, bool isRefresh = true}) async {
    _streamController.add(communityCommentState.loading);
    if (isRefresh) {
      _canLoadMore = true;
      _page = 1;
      _commentList.clear();
    }
    final response =
        await _repository.getCommunityCommentList(communityId, _page, 10, null);
    if (response.error == null && (response.data.isNotEmpty || _page <= 1)) {
      _commentList.addAll(response.data);
      _canLoadMore = response.total > _commentList.length;
      _page += 1;
      _streamController.add(communityCommentState.success);
      final future = _commentList.map((e) async {
        e.childCommentList = await getChildCommentList(
            communityId: communityId, parentId: e.id.toString());
        if (e.childComment > 0) {
          _childComment[e.id] = false;
        }
      }).toList();
      await Future.wait(future);
    } else {
      _canLoadMore = false;
      _streamController.add(_commentList.isNotEmpty
          ? communityCommentState.success
          : communityCommentState.empty);
    }
    notifyListeners();
  }

  void addChildComment(CommunityComment comment) {
    _commentList
        .where((element) => element.id.toString() == comment.parentId)
        .map((e) => e.childCommentList.add(comment))
        .toList();
    notifyListeners();
  }

  void addParentComment(CommunityComment comment) {
    _commentList.insert(0, comment);
    notifyListeners();
  }

  Future<String> setLike(int id, String type, int index) async {
    final result = await _repository.likeUnlikeCommunity(type, id.toString());
    _commentList[index].isLike = !_commentList[index].isLike;
    if (!_commentList[index].isLike) {
      _commentList[index].totalLike -= 1;
    } else {
      _commentList[index].totalLike += 1;
    }
    notifyListeners();
    return result;
  }

  Future<List<CommunityComment>> getChildCommentList(
      {String communityId,
      String parentId,
      int limit = 10,
      int page = 1}) async {
    final response = await _repository.getCommunityCommentList(
        communityId, page, limit, parentId);
    if (response.error == null) {
      return response.data;
    }
    return [];
  }
}

enum communityCommentState { loading, empty, success }
