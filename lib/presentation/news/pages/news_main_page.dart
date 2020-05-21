import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/news/provider/news_article_provider.dart';
import 'package:localin/presentation/news/provider/news_header_provider.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:localin/presentation/news/provider/news_published_article_provider.dart';
import 'package:localin/presentation/news/widgets/news_tab_content.dart';
import 'package:provider/provider.dart';

class NewsMainPage extends StatefulWidget {
  static const routeName = 'NewsPage';
  @override
  _NewsMainPageState createState() => _NewsMainPageState();
}

class _NewsMainPageState extends State<NewsMainPage> {
  @override
  void initState() {
    locator<AnalyticsService>().setScreenName(name: 'NewsPage');
    super.initState();
  }

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
        ChangeNotifierProvider<NewsMyArticleProvider>(
          create: (_) => NewsMyArticleProvider(),
        ),
        ChangeNotifierProvider<NewsPublishedArticleProvider>(
          create: (_) => NewsPublishedArticleProvider(),
        )
      ],
      child: NewsTabContent(),
    );
  }
}
