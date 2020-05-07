import 'package:flutter/material.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/article/shared_article_components/empty_article.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/provider/news_myarticle_provider.dart';
import 'package:provider/provider.dart';

class MyTrashArticle extends StatefulWidget {
  @override
  _MyTrashArticleState createState() => _MyTrashArticleState();
}

class _MyTrashArticleState extends State<MyTrashArticle>
    with AutomaticKeepAliveClientMixin {
  Future getTrashedArticle;
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
            .canLoadMoreTrashArticleList) {
      loadArticle(isRefresh: false);
    }
  }

  loadArticle({bool isRefresh = true}) {
    getTrashedArticle =
        Provider.of<NewsMyArticleProvider>(context, listen: false)
            .getUserTrashArticle(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        loadArticle(isRefresh: true);
      },
      child: FutureBuilder<List<ArticleDetail>>(
        future: getTrashedArticle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              Provider.of<NewsMyArticleProvider>(context, listen: false)
                      .userArticleTrashOffset <=
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
              primary: false,
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
              itemCount: snapshot.data.length + 1 ?? 1,
              itemBuilder: (context, index) {
                if (Provider.of<NewsMyArticleProvider>(context, listen: false)
                            .userArticleTrashOffset <=
                        2 &&
                    snapshot?.data?.length == 0) {
                  return EmptyArticle();
                } else if (index < snapshot?.data?.length) {
                  return ArticleSingleCard(snapshot.data[index]);
                } else if (Provider.of<NewsMyArticleProvider>(context,
                        listen: false)
                    .canLoadMoreTrashArticleList) {
                  /// This load more should be load more to trashed article
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
