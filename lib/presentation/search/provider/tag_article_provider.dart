import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';

class TagArticleProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _canLoadMoreArticle = true;

  bool get canLoadMoreArticle => _canLoadMoreArticle;

  int _offsetRequest = 1, _limitPageRequest = 10;

  int get offsetRequest => _offsetRequest;

  List<ArticleDetail> _listArticle = [];

  Future<List<ArticleDetail>> getArticleByTag(String id,
      {bool isRefresh = true}) async {
    if (isRefresh) {
      _listArticle.clear();
      _offsetRequest = 1;
      _canLoadMoreArticle = true;
    }
    final response = await _repository.getArticleByTag(
        _offsetRequest, _limitPageRequest, id);
    if (response != null && response.error == null) {
      _offsetRequest += 1;
      _listArticle.addAll(response.data);
      _canLoadMoreArticle = response.total > _listArticle.length;
      notifyListeners();
      return _listArticle;
    } else {
      _canLoadMoreArticle = false;
      return _listArticle;
    }
  }
}
