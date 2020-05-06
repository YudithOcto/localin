import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_body_content_widget.dart';
import 'package:localin/presentation/news/widgets/news_detail/news_detail_content_bottom_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class NewsDetailContentWidget extends StatefulWidget {
  final ArticleDetail articleDetail;
  NewsDetailContentWidget({this.articleDetail});

  @override
  _NewsDetailContentWidgetState createState() =>
      _NewsDetailContentWidgetState();
}

class _NewsDetailContentWidgetState extends State<NewsDetailContentWidget> {
  bool isInit = true;
  ArticleDetail _articleDetail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      _articleDetail = widget.articleDetail ?? ArticleDetail();
      isInit = false;
    }
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).pop(_articleDetail);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.black0,
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(_articleDetail),
            child: Icon(
              Icons.arrow_back,
              color: ThemeColors.black80,
            ),
          ),
          titleSpacing: 0.0,
          title: Container(
            margin: EdgeInsets.only(right: 80.0),
            child: Text(
              'Local News',
              overflow: TextOverflow.ellipsis,
              style: ThemeText.sfMediumHeadline,
            ),
          ),
          flexibleSpace: SafeArea(
            child: Container(
              alignment: FractionalOffset.center,
              margin: EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () async {
                        final response =
                            await Provider.of<NewsDetailProvider>(context)
                                .bookmarkArticle(_articleDetail.id);
                        if (response.error != null) {
                          CustomToast.showCustomToast(context, response.error);
                        } else {
                          CustomToast.showCustomBookmarkToast(
                              context, response?.message, callback: () async {
                            dismissAllToast(showAnim: true);
                            await Provider.of<NewsDetailProvider>(context)
                                .bookmarkArticle(_articleDetail.id);
                            setState(() {
                              _articleDetail?.isBookmark =
                                  _articleDetail?.isBookmark == 0 ? 1 : 0;
                            });
                          });
                          setState(() {
                            _articleDetail?.isBookmark =
                                _articleDetail?.isBookmark == 0 ? 1 : 0;
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        !_articleDetail.isBookmark.isBookmarked
                            ? 'images/bookmark_outline.svg'
                            : 'images/bookmark_full.svg',
                        color: _articleDetail.isBookmark.isBookmarked
                            ? ThemeColors.primaryBlue
                            : null,
                      )),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                      onTap: () {
                        Share.text(
                            'Localin', '${_articleDetail?.slug}', 'text/plain');
                      },
                      child: SvgPicture.asset('images/share_article.svg')),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: NewsDetailBodyContentWidget(
                articleDetail: _articleDetail,
              ),
            ),
            NewsDetailContentBottomWidget(
              articleDetail: _articleDetail,
            ),
          ],
        ),
      ),
    );
  }
}

extension on int {
  bool get isBookmarked {
    return this == 1;
  }

  bool get active {
    return this == 1;
  }
}
