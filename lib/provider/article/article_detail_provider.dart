import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/model/article/article_detail.dart';

class ArticleDetailProvider with ChangeNotifier {
  ArticleDetail articleModel;
  Repository _repository;
  TextEditingController _commentController;
  StreamController<List<ArticleCommentDetail>> _streamArticleDetail;
  List<ArticleCommentDetail> commentDetail = List();

  ArticleDetailProvider(ArticleDetail model) {
    this.articleModel = model;
    _repository = Repository();
    _commentController = TextEditingController();
    _streamArticleDetail =
        StreamController<List<ArticleCommentDetail>>.broadcast();
  }

  Future<List<ArticleCommentDetail>> getArticleComment(
      int offset, int limit) async {
    final result = await _repository.getArticleComment(articleModel.id);
    if (result != null && result.error == false) {
      commentDetail.clear();
      commentDetail.addAll(result.comments);
      if (!_streamArticleDetail.isClosed) {
        _streamArticleDetail.add(result.comments);
      }
      return result.comments;
    } else {
      _streamArticleDetail.add(null);
      throw Exception();
    }
  }

  publishComment() async {
    final result = await _repository.publishArticleComment(
        articleModel.id, commentController.text);
    if (result != null && result.error == false) {
      result.postCommentResult.sender = 'me';
      commentDetail.add(result.postCommentResult);
      _streamArticleDetail.add(null);
      if (!_streamArticleDetail.isClosed) {
        _streamArticleDetail.add(commentDetail);
      }
      _commentController.clear();
      return null;
    } else {
      return result.message;
    }
  }

  Future<ArticleBaseResponse> bookmarkArticle() async {
    final response = await _repository.bookmarkArticle(articleModel.id);
    return response;
  }

  TextEditingController get commentController => _commentController;
  Stream<List<ArticleCommentDetail>> get commentStream =>
      _streamArticleDetail.stream;

  @override
  void dispose() {
    _commentController.dispose();
    _streamArticleDetail.close();
    super.dispose();
  }
}
