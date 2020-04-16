import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/pages/create_article_page.dart';
import 'package:localin/presentation/home/widget/articles/article_single_card.dart';
import 'package:localin/presentation/home/widget/articles/empty_article.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class RowArticle extends StatefulWidget {
  @override
  _RowArticleState createState() => _RowArticleState();
}

class _RowArticleState extends State<RowArticle> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      Provider.of<HomeProvider>(context, listen: false)
          .getArticleList(isRefresh: true);
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SvgPicture.asset('images/star_orange.svg'),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'What\'s on',
                    textAlign: TextAlign.center,
                    style: ThemeText.sfSemiBoldHeadline,
                  )
                ],
              ),
              InkWell(
                onTap: () async {
                  final result = await Navigator.of(context)
                      .pushNamed(CreateArticlePage.routeName);
                  if (result != null) {
                    /// refresh current page
                  }
                },
                child: Text(
                  'More articles',
                  textAlign: TextAlign.center,
                  style: ThemeText.sfSemiBoldHeadline
                      .copyWith(color: ThemeColors.primaryBlue),
                ),
              )
            ],
          ),
          PagewiseListView<ArticleDetail>(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            pageSize: 10,
            itemBuilder: (context, item, index) {
              return ArticleSingleCard(item);
            },
            noItemsFoundBuilder: (context) => EmptyArticle(),
            loadingBuilder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
            pageFuture: (pageIndex) =>
                Provider.of<HomeProvider>(context, listen: false)
                    .getArticleList(offset: pageIndex + 1),
          )
//          StreamBuilder<articleState>(
//            stream:
//                Provider.of<HomeProvider>(context, listen: false).articleStream,
//            builder: (context, snapshot) {
//              final homeProvider = Provider.of<HomeProvider>(context);
//              if (snapshot.connectionState == ConnectionState.waiting) {
//                return Center(
//                  child: CircularProgressIndicator(),
//                );
//              } else {
//                if (snapshot.hasData) {
//                  if (snapshot.data == articleState.Loading) {
//                    return Center(
//                      child: CircularProgressIndicator(),
//                    );
//                  } else if (snapshot.data == articleState.NoData) {
//                    return EmptyArticle();
//                  } else {
////                    return ListView.builder(
////                      shrinkWrap: true,
////                      physics: ClampingScrollPhysics(),
////                      itemCount: homeProvider.articleDetail != null &&
////                              homeProvider.articleDetail.isNotEmpty
////                          ? homeProvider.articleDetail.length
////                          : 0,
////                      itemBuilder: (context, index) {
////                        return ArticleSingleCard(
////                            homeProvider.articleDetail[index]);
////                      },
////                    );
//                  }
//                } else {
//                  return Container();
//                }
//              }
//            },
//          ),
//          Consumer<HomeProvider>(
//            builder: (context, provider, child) {
//              if (provider.articleDetail == null) {
//                return EmptyArticle();
//              } else {
//                return LoadMore(
//                  onLoadMore: provider.getArticleList(),
//                  delegate: DefaultLoadMoreDelegate(),
//                  child: ListView.builder(
//                    itemCount: provider.articleDetail != null &&
//                            provider.articleDetail.isNotEmpty
//                        ? provider.articleDetail.length + 1
//                        : 0,
//                    shrinkWrap: true,
//                    physics: ClampingScrollPhysics(),
//                    itemBuilder: (context, index) {
//                      if (index == provider.total) {
//                        return Container();
//                      } else if (provider.articleDetail.length == index) {
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      }
//                      return ArticleSingleCard(provider?.articleDetail[index]);
//                    },
//                  ),
//                );
//              }
//            },
//          )
        ],
      ),
    );
  }

  Future<bool> loadMore(HomeProvider provider) async {
    //return false;
    if (provider.total >= provider.articleDetail.length - 1) {
      print(false);
      return false;
    } else {
      print(true);
      await provider.getArticleList(isRefresh: false);
      return true;
    }
  }
}
