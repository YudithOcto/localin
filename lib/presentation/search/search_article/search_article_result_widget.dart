import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/shared_widgets/article_single_card.dart';
import 'package:localin/presentation/shared_widgets/empty_article.dart';
import 'package:localin/presentation/search/provider/search_article_provider.dart';
import 'package:provider/provider.dart';

class SearchArticleResultWidget extends StatefulWidget {
  @override
  _SearchArticleResultWidgetState createState() =>
      _SearchArticleResultWidgetState();
}

class _SearchArticleResultWidgetState extends State<SearchArticleResultWidget> {
  final ScrollController _searchArticleScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    locator<AnalyticsService>().setScreenName(name: 'SearchArticleTab');
    _searchArticleScrollController..addListener(_listen);
    Future.delayed(Duration.zero, () {
      Provider.of<SearchArticleProvider>(context, listen: false)
          .getArticle(isRefresh: true);
    });
  }

  _listen() {
    if (_searchArticleScrollController.offset >=
        _searchArticleScrollController.position.maxScrollExtent) {
      Provider.of<SearchArticleProvider>(context, listen: false)
          .getArticle(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchArticleProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            Provider.of<SearchArticleProvider>(context, listen: false)
                .getArticle(isRefresh: true);
          },
          child: StreamBuilder<SearchArticleState>(
              stream: provider.searchArticleStream,
              builder: (context, snapshot) {
                if (snapshot.data == SearchArticleState.isLoading &&
                    provider.offsetPage <= 1) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: _searchArticleScrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    physics: ClampingScrollPhysics(),
                    itemCount: provider.articleList.length + 1,
                    itemBuilder: (context, index) {
                      if (snapshot.data == SearchArticleState.isEmpty) {
                        return EmptyArticle();
                      } else if (index < provider.articleList.length) {
                        return ArticleSingleCard(provider.articleList[index]);
                      } else if (provider.isCanLoadMoreArticle) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              }),
        );
      },
    );
  }
}
