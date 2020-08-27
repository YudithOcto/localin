import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_content_widget.dart';
import 'package:provider/provider.dart';

class NewsDetailPage extends StatelessWidget {
  static const routeName = 'NewsDetailPage';
  static const newsSlug = 'newsSlug';
  static const videoSlug = 'videoSlug';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String videoUrl = routeArgs[videoSlug];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsDetailProvider>(
          create: (_) => NewsDetailProvider(url: videoUrl),
        )
      ],
      child: NewsDetailContentWidget(
        videoUrl: videoUrl,
      ),
    );
  }
}
