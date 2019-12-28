import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';

class ArticleDetailProvider with ChangeNotifier {
  ArticleDetail articleModel;

  ArticleDetailProvider(ArticleDetail model) {
    this.articleModel = model;
  }
}
