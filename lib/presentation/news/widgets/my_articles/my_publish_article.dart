import 'package:flutter/material.dart';
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
        loadArticle(isRefresh: true);
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
                  top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              primary: false,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
              itemCount: snapshot.data.isNotNullNorEmpty
                  ? snapshot.data.length + 1
                  : 1,
              itemBuilder: (context, index) {
                if (snapshot.data.length == 0 &&
                    Provider.of<NewsMyArticleProvider>(context, listen: false)
                            .userArticleOffset <=
                        2) {
                  return EmptyArticle();
                } else if (index < snapshot.data.length) {
                  return ArticleSingleCard(snapshot.data[index]);
                } else if (Provider.of<NewsMyArticleProvider>(context,
                        listen: false)
                    .canLoadMoreArticleList) {
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
