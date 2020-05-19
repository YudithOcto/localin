import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_content_widget.dart';
import 'package:provider/provider.dart';

class NewsDetailPage extends StatelessWidget {
  static const routeName = 'NewsDetailPage';
  static const newsSlug = 'newsSlug';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsDetailProvider>(
          create: (_) => NewsDetailProvider(),
        )
      ],
      child: NewsDetailContentWidget(),
    );
  }
}
