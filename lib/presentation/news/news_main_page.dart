import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/news_article_provider.dart';
import 'package:localin/presentation/news/provider/news_header_provider.dart';
import 'package:localin/presentation/news/widgets/news_content.dart';
import 'package:provider/provider.dart';

class NewsMainPage extends StatefulWidget {
  static const routeName = '/newsMainPage';
  @override
  _NewsMainPageState createState() => _NewsMainPageState();
}

class _NewsMainPageState extends State<NewsMainPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsHeaderProvider>(
          create: (_) => NewsHeaderProvider(),
        ),
        ChangeNotifierProvider<NewsArticleProvider>(
          create: (_) => NewsArticleProvider(),
        ),
      ],
      child: NewsContent(),
    );
  }
}
