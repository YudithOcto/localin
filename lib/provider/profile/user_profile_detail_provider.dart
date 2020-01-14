import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';

class UserProfileProvider with ChangeNotifier {
  Repository _repository = Repository();
  List<ArticleDetail> article = List();
  bool isUserDanaAccountActive = false;

  Future<String> getUserArticle() async {
    final response = await _repository.getUserArticle();
    await getUserDanaStatus();
    if (response.data != null) {
      article.clear();
      article.addAll(response.data);
      article.insert(0, ArticleDetail());
      article.insert(article.length, ArticleDetail());
      return response.message;
    }
    return response.error;
  }

  Future<void> getUserDanaStatus() async {
    final response = await _repository.getUserDanaStatus();
    if (response.error == null) {
      this.isUserDanaAccountActive = true;
    } else {
      this.isUserDanaAccountActive = false;
    }
  }
}
