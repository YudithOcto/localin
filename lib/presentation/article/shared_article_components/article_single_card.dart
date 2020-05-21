import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/article/shared_article_components/row_like_widget.dart';
import 'package:localin/presentation/home/widget/articles/row_bookmark.dart';
import 'package:localin/presentation/news/pages/news_detail_page.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/presentation/webview/article_webview.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:localin/utils/image_helper.dart';
import 'package:html/parser.dart' as parser;
import 'package:palette_generator/palette_generator.dart';

class ArticleSingleCard extends StatefulWidget {
  final ArticleDetail articleDetail;
  final ValueChanged<bool> onRefresh;
  final ValueChanged<bool> onUndo;
  final BoxFit imageFit;
  final Function(String) showPopup;

  ArticleSingleCard(this.articleDetail,
      {this.onRefresh,
      this.onUndo,
      this.imageFit = BoxFit.fill,
      this.showPopup});

  @override
  _ArticleSingleCardState createState() => _ArticleSingleCardState();
}

const kArticleMediaType = 'media';

const popupItem = ['Archive'];

class _ArticleSingleCardState extends State<ArticleSingleCard> {
  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.lightMutedColor.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0, top: 12.0),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 20.0,
            right: -15.0,
            child: Visibility(
              visible: widget.showPopup != null,
              child: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: ThemeColors.black100,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  onSelected: (v) {
                    widget.showPopup(widget.articleDetail.id);
                  },
                  itemBuilder: (context) {
                    return popupItem
                        .map((e) => PopupMenuItem(
                              value: e,
                              child: Text('$e'),
                            ))
                        .toList();
                  }),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              bigImages(context),
              SizedBox(
                height: 12.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RevampOthersProfilePage.routeName, arguments: {
                    RevampOthersProfilePage.userId:
                        widget?.articleDetail?.createdBy,
                  });
                },
                child: Text(
                  'by ${widget?.articleDetail?.author}',
                  style: ThemeText.sfMediumBody
                      .copyWith(color: ThemeColors.black80),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              InkWell(
                onTap: () => openArticle(),
                child: Text(
                  '${parseHtml(widget?.articleDetail?.title)}',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.black100),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      widget?.articleDetail?.type != kArticleMediaType
                          ? rowMessage()
                          : RowBookmark(
                              articleDetail: widget?.articleDetail,
                              onRefresh: (v) => widget.onRefresh(v),
                              onUndo: (v) => widget.onUndo(v),
                            ),
                      SizedBox(
                        width: 9.67,
                      ),
                      widget?.articleDetail?.type != kArticleMediaType
                          ? RowLikeWidget(
                              articleDetail: widget?.articleDetail,
                            )
                          : rowShare(),
                    ],
                  ),
                  Text(
                      '${DateHelper.timeAgo(DateTime.parse(widget?.articleDetail?.createdAt))}',
                      style: ThemeText.sfMediumBody
                          .copyWith(color: ThemeColors.black80))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bigImages(BuildContext context) {
    return InkWell(
      onTap: () => openArticle(),
      child: CachedNetworkImage(
        imageUrl: ImageHelper.addSubFixHttp(widget.articleDetail?.image),
        placeholderFadeInDuration: Duration(milliseconds: 250),
        imageBuilder: (context, imageProvider) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: ThemeColors.black80,
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                      image: imageProvider, fit: widget.imageFit)),
            ),
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

  openArticle() async {
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
      final result = await Navigator.of(context)
          .pushNamed(NewsDetailPage.routeName, arguments: {
        NewsDetailPage.newsSlug: widget?.articleDetail?.slug,
      });
      if (result != null && result is ArticleDetail) {
        widget.articleDetail.isLike = result.isLike;
        widget.articleDetail.totalLike = result.totalLike;
        widget.articleDetail.isBookmark = result.isBookmark;
        widget.articleDetail.totalComment = result.totalComment;
        setState(() {});
      }
    }
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
            '${widget?.articleDetail?.totalComment ?? 0}',
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

  parseHtml(String data) {
    final doc = parser.parse(data);
    return parser.parse(doc.body.text).documentElement.text;
  }
}
