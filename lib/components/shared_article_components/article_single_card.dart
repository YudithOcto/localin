import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/home/widget/articles/row_bookmark.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/presentation/webview/article_webview.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/utils/image_helper.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class ArticleSingleCard extends StatefulWidget {
  final ArticleDetail articleDetail;
  ArticleSingleCard(this.articleDetail);

  @override
  _ArticleSingleCardState createState() => _ArticleSingleCardState();
}

const kArticleMediaType = 'media';

class _ArticleSingleCardState extends State<ArticleSingleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0, top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          bigImages(context),
          SizedBox(
            height: 12.0,
          ),
          InkWell(
            onTap: () {
              if (widget?.articleDetail?.type != kArticleMediaType) {
                Navigator.of(context)
                    .pushNamed(RevampOthersProfilePage.routeName, arguments: {
                  RevampOthersProfilePage.userId:
                      widget?.articleDetail?.createdBy,
                });
              }
            },
            child: Text(
              'by ${widget?.articleDetail?.author}',
              style:
                  ThemeText.sfMediumBody.copyWith(color: ThemeColors.black80),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          InkWell(
            onTap: () async {
              if (widget?.articleDetail?.type == kArticleMediaType) {
                final result = await Navigator.of(context)
                    .pushNamed(ArticleWebView.routeName, arguments: {
                  ArticleWebView.url: widget.articleDetail.slug
                          .contains('https')
                      ? widget.articleDetail.slug
                      : widget.articleDetail.slug.replaceRange(0, 4, 'https'),
                  ArticleWebView.articleModel: widget.articleDetail,
                });
                if (result != null) {
                  setState(() {
                    widget?.articleDetail?.isBookmark = result;
                  });
                }
              } else {
                Navigator.of(context)
                    .pushNamed(ArticleDetailPage.routeName, arguments: {
                  ArticleDetailPage.articleId: widget.articleDetail?.slug,
                  ArticleDetailPage.commentPage: false,
                });
              }
            },
            child: Text(
              '${widget?.articleDetail?.title}',
              style:
                  ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black100),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              widget?.articleDetail?.type != kArticleMediaType
                  ? rowMessage()
                  : RowBookmark(
                      articleDetail: widget?.articleDetail,
                    ),
              SizedBox(
                width: 9.67,
              ),
              widget?.articleDetail?.type != kArticleMediaType
                  ? rowLike()
                  : rowShare(),
            ],
          )
        ],
      ),
    );
  }

  Widget bigImages(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget?.articleDetail?.type == kArticleMediaType) {
          final result = await Navigator.of(context)
              .pushNamed(ArticleWebView.routeName, arguments: {
            ArticleWebView.url: widget.articleDetail.slug.contains('https')
                ? widget.articleDetail.slug
                : widget.articleDetail.slug.replaceRange(0, 4, 'https'),
            ArticleWebView.articleModel: widget.articleDetail,
          });
          if (result != null) {
            setState(() {
              widget?.articleDetail?.isBookmark = result;
            });
          }
        } else {
          Navigator.of(context)
              .pushNamed(ArticleDetailPage.routeName, arguments: {
            ArticleDetailPage.articleId: widget.articleDetail?.slug,
            ArticleDetailPage.commentPage: false,
          });
        }
      },
      child: CachedNetworkImage(
        imageUrl: ImageHelper.addSubFixHttp(widget.articleDetail?.image),
        placeholderFadeInDuration: Duration(milliseconds: 250),
        imageBuilder: (context, imageProvider) {
          return Container(
            width: double.infinity,
            height: 188.0,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          );
        },
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: ThemeColors.black80),
          width: double.infinity,
          height: 188.0,
        ),
        errorWidget: (_, url, child) => Container(
          width: double.infinity,
          height: 188.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: ThemeColors.black80),
        ),
      ),
    );
  }

  Widget rowLike() {
    return InkWell(
      onTap: () async {
        if (widget?.articleDetail?.isLike == 0) {
          final response = await Provider.of<HomeProvider>(context)
              .likeArticle(widget.articleDetail.id);
          if (response.error != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('${response?.error}'),
            ));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('${response?.message}'),
              duration: Duration(milliseconds: 300),
            ));
            setState(() {
              widget.articleDetail?.isLike =
                  widget.articleDetail?.isLike == 0 ? 1 : 0;
              widget.articleDetail?.totalLike += 1;
            });
          }
        }
      },
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            'images/love.svg',
            color: widget.articleDetail.isLike == 1
                ? ThemeColors.primaryBlue
                : ThemeColors.black80,
            width: 16.0,
            height: 16.0,
          ),
          SizedBox(
            width: 5.59,
          ),
          Text(
            '${widget?.articleDetail?.totalLike}',
            style:
                ThemeText.sfSemiBoldBody.copyWith(color: ThemeColors.black80),
          ),
        ],
      ),
    );
  }

  Widget rowMessage() {
    return InkWell(
      onTap: () {
        if (widget?.articleDetail?.type != kArticleMediaType) {
          Navigator.of(context)
              .pushNamed(ArticleDetailPage.routeName, arguments: {
            ArticleDetailPage.articleId: widget.articleDetail?.slug,
            ArticleDetailPage.commentPage: true,
          });
        }
      },
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            'images/chat.svg',
            width: 16.0,
            height: 16.0,
          ),
          SizedBox(
            width: 5.59,
          ),
          Text(
            '${widget?.articleDetail?.totalComment}',
            style:
                ThemeText.sfSemiBoldBody.copyWith(color: ThemeColors.black80),
          ),
        ],
      ),
    );
  }

  Widget rowShare() {
    return InkWell(
      onTap: () {
        Share.text('Localin', '${widget?.articleDetail?.slug}', 'text/plain');
      },
      child: SvgPicture.asset('images/share_article.svg'),
    );
  }
}
