import 'package:flutter/material.dart';
import 'package:localin/presentation/news/provider/news_header_provider.dart';
import 'package:localin/presentation/news/widgets/latest/latest_article_widget.dart';
import 'package:localin/presentation/news/widgets/my_articles//my_collection_article.dart';
import 'package:localin/presentation/news/widgets/news_main_header.dart';
import 'package:provider/provider.dart';

import 'collection/collection_article_widget.dart';

class NewsTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          NewsMainHeader(),
          Expanded(
            child: PageView(
              controller:
                  Provider.of<NewsHeaderProvider>(context, listen: false)
                      .pageController,
              onPageChanged: (value) {
                Provider.of<NewsHeaderProvider>(context, listen: false)
                    .setHeaderSelected(value);
              },
              children: <Widget>[
                LatestArticleWidget(),
                MyCollectionArticle(),
                CollectionArticleWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
