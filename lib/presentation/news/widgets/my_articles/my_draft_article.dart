import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/article/shared_article_components/empty_article.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:provider/provider.dart';

class MyDraftArticle extends StatefulWidget {
  @override
  _MyDraftArticleState createState() => _MyDraftArticleState();
}

class _MyDraftArticleState extends State<MyDraftArticle>
    with AutomaticKeepAliveClientMixin {
  Future getDraftArticle;
  bool _isInit = true;
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      locator<AnalyticsService>().setScreenName(name: 'ArticleDraftTab');
      loadArticle();
      _scrollController = ScrollController()..addListener(_listener);
      _isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .isCanLoadMoreDraftArticle) {
      loadArticle(isRefresh: false);
    }
  }

  loadArticle({bool isRefresh = true}) {
    getDraftArticle = Provider.of<NewsMyArticleProvider>(context, listen: false)
        .getUserDraftArticle(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        loadArticle(isRefresh: true);
      },
      child: Consumer<NewsMyArticleProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<List<ArticleDetail>>(
            future: getDraftArticle,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  provider.userArticleDraftOffset <= 1) {
                return Container(
                  alignment: FractionalOffset.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                  itemCount: snapshot.data.isNotNullNorEmpty
                      ? snapshot.data.length + 1
                      : 1,
                  itemBuilder: (context, index) {
                    if (snapshot.data.length == 0 &&
                        provider.userArticleDraftOffset <= 2) {
                      return EmptyArticle();
                    } else if (index < snapshot.data.length) {
                      return ArticleSingleCard(snapshot.data[index]);
                    } else if (provider.isCanLoadMoreDraftArticle) {
                      /// This load more should be load more to draft
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
            },
          );
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
