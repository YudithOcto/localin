import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../../themes.dart';

class RowBookmark extends StatefulWidget {
  final ArticleDetail articleDetail;
  RowBookmark({this.articleDetail});
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
          CustomToast.showCustomBookmarkToast(context, response?.message,
              callback: () async {
            dismissAllToast(showAnim: true);
            await Provider.of<HomeProvider>(context)
                .bookmarkArticle(widget.articleDetail.id);
            setState(() {
              widget.articleDetail?.isBookmark =
                  widget.articleDetail?.isBookmark == 0 ? 1 : 0;
            });
          });
          setState(() {
            widget.articleDetail?.isBookmark =
                widget.articleDetail?.isBookmark == 0 ? 1 : 0;
          });
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
}
