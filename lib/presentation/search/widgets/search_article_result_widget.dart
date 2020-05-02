import 'package:flutter/material.dart';
import 'package:localin/components/shared_article_components/article_single_card.dart';
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
    _searchArticleScrollController..addListener(_listen);
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
                if (snapshot.data == SearchArticleState.isEmpty) {
                  return Container();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    physics: ClampingScrollPhysics(),
                    itemCount: provider.articleList != null &&
                            provider.articleList.isNotEmpty
                        ? provider.articleList.length + 1
                        : 1,
                    itemBuilder: (context, index) {
                      if (provider.articleList.length == 0) {
                        return Container();
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
