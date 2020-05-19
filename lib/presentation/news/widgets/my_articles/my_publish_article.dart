import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/article/shared_article_components/empty_article.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:provider/provider.dart';

class MyPublishArticle extends StatefulWidget {
  @override
  _MyPublishArticleState createState() => _MyPublishArticleState();
}

class _MyPublishArticleState extends State<MyPublishArticle>
    with AutomaticKeepAliveClientMixin {
  Future getPublishedArticle;
  bool _isInit = true;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      locator<AnalyticsService>().setScreenName(name: 'ArticlePublishTab');
      loadArticle();
      _scrollController = ScrollController()..addListener(_listener);
      _isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .canLoadMoreArticleList) {
      loadArticle(isRefresh: false);
    }
  }

  loadArticle({bool isRefresh = true}) {
    getPublishedArticle =
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .getUserArticle(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          loadArticle(isRefresh: true);
        });
      },
      child: FutureBuilder<List<ArticleDetail>>(
        future: getPublishedArticle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              Provider.of<NewsMyArticleProvider>(context, listen: false)
                      .userArticleOffset <=
                  1) {
            return Container(
              alignment: FractionalOffset.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<NewsMyArticleProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  primary: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                  itemCount: provider.userArticleList.isNotNullNorEmpty
                      ? provider.userArticleList.length + 1
                      : 1,
                  itemBuilder: (context, index) {
                    if (provider.userArticleList.length == 0 &&
                        provider.userArticleOffset <= 2) {
                      return EmptyArticle();
                    } else if (index < provider.userArticleList.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ArticleSingleCard(
                          provider.userArticleList[index],
                          imageFit: BoxFit.cover,
                        ),
                      );
                    } else if (provider.canLoadMoreArticleList) {
                      /// This load more should be load more to published article
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
              },
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

extension on List {
  bool get isNotNullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}
