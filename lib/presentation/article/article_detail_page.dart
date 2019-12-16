import 'package:flutter/material.dart';
import 'package:localin/presentation/article/widget/banner_article.dart';
import 'package:localin/presentation/article/widget/row_header_article.dart';
import 'package:localin/presentation/article/widget/tab_bar_header.dart';

import '../../themes.dart';

class ArticleDetailPage extends StatefulWidget {
  static const routeName = '/articleDetailPage';
  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Image.asset(
          'images/app_bar_logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 50.0,
        ),
      ),
      body: ListView(
        children: <Widget>[
          BannerArticle(),
          RowHeaderArticle(),
          TabBarHeader(),
        ],
      ),
    );
  }
}
