import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/news/comment_page.dart';
import 'package:localin/presentation/news/provider/news_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class NewsDetailContentBottomWidget extends StatefulWidget {
  final ArticleDetail articleDetail;
  NewsDetailContentBottomWidget({@required this.articleDetail});
  @override
  _NewsDetailContentBottomWidgetState createState() =>
      _NewsDetailContentBottomWidgetState();
}

class _NewsDetailContentBottomWidgetState
    extends State<NewsDetailContentBottomWidget> {
  ArticleDetail _articleDetail;
  @override
  void initState() {
    _articleDetail = widget.articleDetail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: ThemeColors.bgNavigation,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () {
                if (_articleDetail.isLike.active) {
                  unLikedArticle();
                } else {
                  likeArticle();
                }
              },
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    _articleDetail.isLike.active
                        ? 'images/ic_like_full.svg'
                        : 'images/ic_like_outline.svg',
                    color:
                        _articleDetail.isLike.active ? ThemeColors.red : null,
                  ),
                  SizedBox(
                    width: 9.0,
                  ),
                  Text('${_articleDetail.totalLike ?? 0} liked',
                      style: ThemeText.sfSemiBoldFootnote.copyWith(
                          color: _articleDetail.isLike.active
                              ? ThemeColors.red
                              : ThemeColors.black80))
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CommentPage.routeName, arguments: {
                  CommentPage.articleDetail: _articleDetail,
                });
              },
              child: Row(
                children: <Widget>[
                  SvgPicture.asset('images/chat.svg'),
                  SizedBox(
                    width: 9.0,
                  ),
                  Text(
                    '${_articleDetail.totalComment ?? 0} comments',
                    style: ThemeText.sfSemiBoldFootnote
                        .copyWith(color: ThemeColors.black80),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  likeArticle() async {
    final provider = Provider.of<NewsDetailProvider>(context, listen: false);
    final response = await provider.likeArticle(_articleDetail.id);
    if (response.error != null) {
      CustomToast.showCustomLikedToast(context,
          message: response?.error, showUndo: false);
    } else {
      CustomToast.showCustomLikedToast(context,
          message: 'Article liked', showUndo: true, callback: () async {
        dismissAllToast(showAnim: true);
        await provider.likeArticle(_articleDetail.id);
        setState(() {
          _articleDetail?.isLike = 0;
          _articleDetail?.totalLike -= 1;
        });
      });
      setState(() {
        _articleDetail?.isLike = 1;
        _articleDetail?.totalLike += 1;
      });
    }
  }

  unLikedArticle() async {
    final provider = Provider.of<NewsDetailProvider>(context, listen: false);
    final response = await provider.likeArticle(_articleDetail.id);
    if (response.error != null) {
      CustomToast.showCustomLikedToast(context,
          message: response?.error, showUndo: false);
    } else {
      CustomToast.showCustomLikedToast(context,
          message: 'Article unliked', showUndo: true, callback: () async {
        dismissAllToast(showAnim: true);
        await provider.likeArticle(_articleDetail.id);
        setState(() {
          _articleDetail?.isLike = 1;
          _articleDetail?.totalLike += 1;
        });
      });
      setState(() {
        _articleDetail?.isLike = 0;
        _articleDetail?.totalLike -= 1;
      });
    }
  }
}

extension on int {
  bool get active {
    return this == 1;
  }
}
