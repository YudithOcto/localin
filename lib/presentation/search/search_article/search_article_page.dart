import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/search/provider/search_article_provider.dart';
import 'package:localin/presentation/search/search_article///search_article_page_content.dart';
import 'package:provider/provider.dart';

class SearchArticlePage extends StatelessWidget {
  static const routeName = 'SearchArticlePage';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchArticleProvider>(
          create: (_) => SearchArticleProvider(
              analyticsService: locator<AnalyticsService>()),
        ),
      ],
      child: SearchArticlePageContent(),
    );
  }
}
