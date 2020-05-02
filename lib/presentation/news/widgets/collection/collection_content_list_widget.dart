import 'package:flutter/material.dart';
import 'package:localin/components/shared_article_components/article_single_card.dart';
import 'package:localin/components/shared_article_components/empty_article.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/provider/news_article_provider.dart';
import 'package:provider/provider.dart';

class CollectionContentListWidget extends StatefulWidget {
  final int isLiked;
  final int isBookmark;
  CollectionContentListWidget({this.isLiked, this.isBookmark});

  @override
  _CollectionContentListWidgetState createState() =>
      _CollectionContentListWidgetState();
}

class _CollectionContentListWidgetState
    extends State<CollectionContentListWidget>
    with AutomaticKeepAliveClientMixin {
  bool isInit = true;
  final ScrollController _scrollController = ScrollController();
  Future getLikedArticle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      onArticleRefresh();
      isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      getLikedArticle = Provider.of<NewsArticleProvider>(context, listen: false)
          .getArticleList(
              isRefresh: false,
              isLiked: widget.isLiked.isNotNull ? widget.isLiked : null,
              isBookmark:
                  widget.isBookmark.isNotNull ? widget.isBookmark : null);
      setState(() {});
    }
  }

  onArticleRefresh() {
    getLikedArticle = Provider.of<NewsArticleProvider>(context, listen: false)
        .getArticleList(
            isLiked: widget.isLiked.isNotNull ? widget.isLiked : null,
            isBookmark: widget.isBookmark.isNotNull ? widget.isBookmark : null);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onArticleRefresh();
        setState(() {});
      },
      child: FutureBuilder<List<ArticleDetail>>(
        future: getLikedArticle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: FractionalOffset.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return EmptyArticle();
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                itemCount: snapshot.data.isNotNullNorEmpty
                    ? snapshot.data.length + 1
                    : 1,
                itemBuilder: (context, index) {
                  if (snapshot.data.length == 0) {
                    return EmptyArticle();
                  } else if (index < snapshot.data.length) {
                    return ArticleSingleCard(snapshot.data[index]);
                  } else if (Provider.of<NewsArticleProvider>(context,
                          listen: false)
                      .canLoadMoreArticle) {
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
          } else {
            return EmptyArticle();
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

extension on int {
  bool get isNotNull {
    return this != null;
  }
}
