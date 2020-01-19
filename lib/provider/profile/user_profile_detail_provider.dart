import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';

class UserProfileProvider with ChangeNotifier {
  Repository _repository = Repository();
  List<ArticleDetail> article = List();
  StreamController<DanaAccountDetail> _danaAccountDetail;

  UserProfileProvider() {
    _danaAccountDetail = StreamController<DanaAccountDetail>.broadcast();
  }

  Future<List<ArticleDetail>> getUserArticle() async {
    final response = await _repository.getUserArticle();
    article.clear();
    article.insert(0, ArticleDetail());
    if (response.data != null) {
      article.addAll(response.data);
      article.insert(article.length, ArticleDetail());
    } else {
      article.insert(article.length, ArticleDetail());
    }
    return article;
  }

  Future<DanaAccountDetail> getUserDanaStatus() async {
    final response = await _repository.getUserDanaStatus();
    if (response.error == null) {
      if (!_danaAccountDetail.isClosed) {
        _danaAccountDetail.add(response.data);
      }
      return response.data;
    } else {
      if (!_danaAccountDetail.isClosed) {
        _danaAccountDetail.add(null);
      }
      return null;
    }
  }

  Stream<DanaAccountDetail> get danaAccountStream => _danaAccountDetail.stream;

  @override
  void dispose() {
    _danaAccountDetail.close();
    super.dispose();
  }
}
