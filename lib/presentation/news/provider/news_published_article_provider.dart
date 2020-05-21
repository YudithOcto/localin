import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';

class NewsPublishedArticleProvider with ChangeNotifier {
  final Repository _repository = Repository();

  int _userArticleOffset = 1;
  int get userArticleOffset => _userArticleOffset;

  List<ArticleDetail> _userArticleList = [];
  List<ArticleDetail> get userArticleList => _userArticleList;

  bool _canLoadMoreArticleList = true;
  bool get canLoadMoreArticleList => _canLoadMoreArticleList;

  bool _isMounted = true;
  StreamController<publishedArticleState> _publishedState =
      StreamController<publishedArticleState>.broadcast();
  Stream<publishedArticleState> get publishedStream => _publishedState.stream;

  Future<Null> getUserArticle({isRefresh = true}) async {
    setState(publishedArticleState.loading);
    if (isRefresh) {
      _userArticleOffset = 1;
      _userArticleList.clear();
      _canLoadMoreArticleList = true;
    }

    final response =
        await _repository.getUserArticle(offset: _userArticleOffset);
    if (response != null && response.error == null) {
      _userArticleList.addAll(response.data);
      _userArticleOffset += 1;
      _canLoadMoreArticleList = response.total > _userArticleList.length;
      setState(publishedArticleState.success);
      notifyListeners();
    } else {
      if (_userArticleList.isNotEmpty) {
        setState(publishedArticleState.success);
      } else {
        setState(publishedArticleState.empty);
      }
      _canLoadMoreArticleList = false;
    }
  }

  setState(publishedArticleState state) {
    if (_isMounted) {
      _publishedState.add(state);
    }
  }

  deleteArticle(String articleId) async {
    await _repository.deleteArticle(articleId);
    getUserArticle();
  }

  @override
  void dispose() {
    _isMounted = false;
    _publishedState.close();
    super.dispose();
  }
}

enum publishedArticleState { loading, success, empty }
