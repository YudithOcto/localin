import 'package:flutter/material.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/widget/banner_article.dart';
import 'package:localin/presentation/article/widget/row_header_article.dart';
import 'package:localin/presentation/article/widget/tab_bar_header.dart';
import 'package:localin/provider/article/article_detail_provider.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatefulWidget {
  static const routeName = '/articleDetailPage';
  static const articleDetailModel = '/articleDetailModel';
  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    ArticleDetail articleModel =
        routeArgs[ArticleDetailPage.articleDetailModel];
    return ChangeNotifierProvider<ArticleDetailProvider>(
      create: (_) => ArticleDetailProvider(articleModel),
      child: Scaffold(
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
        body: Content(),
      ),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        BannerArticle(),
        RowHeaderArticle(),
        TabBarHeader(),
      ],
    );
  }
}
