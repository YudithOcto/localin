import 'package:flutter/material.dart';
import 'package:localin/model/article/article_model.dart';

class ArticleDetailProvider with ChangeNotifier {
  ArticleModel articleModel;

  ArticleDetailProvider(ArticleModel model) {
    this.articleModel = model;
  }
}
