import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_model.dart';

class UserProfileProvider with ChangeNotifier {
  Repository _repository = Repository();
  List<ArticleModel> article = List();

  Future<String> getUserArticle() async {
    var response = await _repository.getUserArticle();
    if (response.data != null) {
      article.clear();
      article.addAll(response.data);
      article.insert(0, ArticleModel());
      article.insert(article.length, ArticleModel());
      return response.message;
    }
    return response.error;
  }
}
