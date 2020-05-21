import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/shared_article_components/article_single_card.dart';
import 'package:localin/presentation/news/pages/news_detail_page.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:localin/presentation/webview/article_webview.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class NewsDetailRelatedWidget extends StatefulWidget {
  final ArticleDetail articleDetail;
  NewsDetailRelatedWidget({this.articleDetail});
  @override
  _NewsDetailRelatedWidgetState createState() =>
      _NewsDetailRelatedWidgetState();
}

class _NewsDetailRelatedWidgetState extends State<NewsDetailRelatedWidget> {
  ArticleDetail _articleDetail;
  Future getRelatedArticle;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _articleDetail = widget.articleDetail;
      getRelatedArticle =
          Provider.of<NewsDetailProvider>(context, listen: false)
              .getRelatedArticle(_articleDetail.id);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleDetail>>(
      future: getRelatedArticle,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data.isNotEmpty) {
            return Container(
              color: ThemeColors.black10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 23.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset('images/star_orange.svg'),
                        SizedBox(
                          width: 5.67,
                        ),
                        Text(
                          'Related',
                          style: ThemeText.sfSemiBoldHeadline,
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot?.data?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () async {
                            if (snapshot?.data[index]?.type ==
                                kArticleMediaType) {
                              final result = await Navigator.of(context)
                                  .pushNamed(ArticleWebView.routeName,
                                      arguments: {
                                    ArticleWebView.url: snapshot
                                            .data[index].slug
                                            .contains('https')
                                        ? snapshot?.data[index].slug
                                        : snapshot?.data[index].slug
                                            .replaceRange(0, 4, 'https'),
                                    ArticleWebView.articleModel:
                                        snapshot?.data[index],
                                  });
                              if (result != null) {
                                setState(() {
                                  widget?.articleDetail?.isBookmark = result;
                                });
                              }
                            } else {
                              final result = await Navigator.of(context)
                                  .pushNamed(NewsDetailPage.routeName,
                                      arguments: {
                                    NewsDetailPage.newsSlug:
                                        snapshot?.data[index].slug,
                                  });
                              if (result != null && result is ArticleDetail) {
                                widget.articleDetail.isLike = result.isLike;
                                widget.articleDetail.totalLike =
                                    result.totalLike;
                                widget.articleDetail.isBookmark =
                                    result.isBookmark;
                                widget.articleDetail.totalComment =
                                    result.totalComment;
                                setState(() {});
                              }
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: snapshot?.data[index].image ?? '',
                                imageBuilder: (context, image) {
                                  return Container(
                                    width: 86.0,
                                    height: 86.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        image: DecorationImage(
                                          image: image,
                                          fit: BoxFit.cover,
                                        )),
                                  );
                                },
                                placeholder: (context, image) => Container(
                                  width: 86.0,
                                  height: 86.0,
                                  decoration: BoxDecoration(
                                    color: ThemeColors.black80,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                errorWidget: (context, image, child) =>
                                    Container(
                                  width: 86.0,
                                  height: 86.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: ThemeColors.black80),
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${snapshot?.data[index]?.title ?? ''}',
                                      style: ThemeText.rodinaTitle3,
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: 'by ',
                                            style: ThemeText.sfMediumBody
                                                .copyWith(
                                                    color:
                                                        ThemeColors.black80)),
                                        TextSpan(
                                            text:
                                                '${snapshot?.data[index]?.author}',
                                            style: ThemeText.sfMediumBody
                                                .copyWith(
                                                    color: ThemeColors
                                                        .primaryBlue)),
                                      ]),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}
