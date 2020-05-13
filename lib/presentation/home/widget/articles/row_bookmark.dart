import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/provider/news_article_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../themes.dart';

class RowBookmark extends StatefulWidget {
  final ArticleDetail articleDetail;
  final ValueChanged<bool> onRefresh;
  final ValueChanged<bool> onUndo;
  RowBookmark({this.articleDetail, this.onRefresh, this.onUndo});
  @override
  _RowBookmarkState createState() => _RowBookmarkState();
}

class _RowBookmarkState extends State<RowBookmark> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final response = await Provider.of<HomeProvider>(context)
            .bookmarkArticle(widget.articleDetail.id);
        if (response.error != null) {
          CustomToast.showCustomToast(context, response.error);
        } else {
          if (widget.articleDetail.isBookmark == 1) {
            unBookmarkArticle();
          } else {
            bookMarkArticle();
          }
        }
      },
      child: SvgPicture.asset(
        widget?.articleDetail?.isBookmark == 0
            ? 'images/bookmark_outline.svg'
            : 'images/bookmark_full.svg',
        color: widget?.articleDetail?.isBookmark == 1
            ? ThemeColors.primaryBlue
            : null,
      ),
    );
  }

  bookMarkArticle() {
    setState(() {
      widget.articleDetail?.isBookmark = 1;
    });
    CustomToast.showCustomBookmarkToast(context, 'Added to Bookmark',
        undoCallback: () async {
      dismissAllToast(showAnim: true);
      await Provider.of<HomeProvider>(context)
          .bookmarkArticle(widget.articleDetail.id);
      setState(() {
        widget.articleDetail?.isBookmark = 0;
      });
    });
  }

  unBookmarkArticle() {
    setState(() {
      widget.articleDetail?.isBookmark = 0;
    });
    CustomToast.showCustomBookmarkToast(context, 'Delete from bookmark',
        undoCallback: () async {
      dismissAllToast(showAnim: true);
      await Provider.of<HomeProvider>(context, listen: false)
          .bookmarkArticle(widget.articleDetail.id);
      setState(() {
        widget.articleDetail?.isBookmark = 1;
      });
    });
  }
}
