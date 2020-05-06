import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/article/shared_article_components/empty_article.dart';
import 'package:localin/presentation/home/widget/row_user_location.dart';
import 'package:localin/presentation/news/provider/news_article_provider.dart';
import 'package:localin/presentation/search/search_article_page.dart';
import 'package:localin/text_themes.dart';
import 'package:provider/provider.dart';

class LatestArticleWidget extends StatefulWidget {
  @override
  _LatestArticleWidgetState createState() => _LatestArticleWidgetState();
}

class _LatestArticleWidgetState extends State<LatestArticleWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<NewsArticleProvider>(context, listen: false).getArticleList();
      _scrollController..addListener(_listener);
      _isInit = false;
    }
  }

  _listener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      Provider.of<NewsArticleProvider>(context, listen: false)
          .getArticleList(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<NewsArticleProvider>(context, listen: false)
            .getArticleList();
      },
      child: ListView(
        shrinkWrap: true,
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(SearchArticlePage.routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: RowUserLocation()),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 20.0),
                  child: SvgPicture.asset(
                    'images/article_search.svg',
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                SvgPicture.asset('images/star_orange.svg'),
                SizedBox(
                  width: 6.0,
                ),
                Text(
                  'What\'s on',
                  style: ThemeText.sfSemiBoldHeadline,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Consumer<NewsArticleProvider>(
            builder: (context, provider, child) {
              return StreamBuilder<NewsArticleState>(
                stream: provider.streamArticle,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      alignment: FractionalOffset.center,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data == NewsArticleState.NoData) {
                      return EmptyArticle();
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                        itemCount: provider.articleList.isNotNullNorEmpty
                            ? provider.articleList.length + 1
                            : 1,
                        itemBuilder: (context, index) {
                          if (provider.articleList.length == 0) {
                            return EmptyArticle();
                          } else if (index < provider.articleList.length) {
                            return ArticleSingleCard(
                                provider.articleList[index]);
                          } else if (provider.canLoadMoreArticle) {
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
                    return Container();
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}

extension on List {
  bool get isNotNullNorEmpty {
    return this != null && this.isNotEmpty;
  }
}
