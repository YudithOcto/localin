import 'package:flutter/material.dart';
import 'package:localin/presentation/search/provider/search_article_provider.dart';
import 'package:localin/presentation/search/widgets/search_article_page_content.dart';
import 'package:provider/provider.dart';

class SearchArticlePage extends StatelessWidget {
  static const routeName = '/searchArticlePage';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchArticleProvider>(
          create: (_) => SearchArticleProvider(),
        ),
      ],
      child: SearchArticlePageContent(),
    );
  }
}
