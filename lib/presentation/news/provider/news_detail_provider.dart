import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_detail.dart';

class NewsDetailProvider with ChangeNotifier {
  final Repository _repository = Repository();

  Future<ArticleBaseResponse> likeArticle(String articleId) async {
    final response = await _repository.likeArticle(articleId);
    return response;
  }

  Future<ArticleBaseResponse> bookmarkArticle(String articleId) async {
    final response = await _repository.bookmarkArticle(articleId);
    return response;
  }

  Future<List<ArticleDetail>> getRelatedArticle(String articleId) async {
    final response = await _repository.getRelatedArticle(articleId);
    if (response != null && response.error == null) {
      return response.data;
    }
    return [];
  }

  Future<ArticleBaseResponse> getArticleDetail(String articleId) async {
    final result = await _repository.getArticleDetail(articleId);
    if (result != null && result.detail != null) {
      //articleModel = result.detail;
      notifyListeners();
      return result;
    } else {
      return null;
    }
  }
}
