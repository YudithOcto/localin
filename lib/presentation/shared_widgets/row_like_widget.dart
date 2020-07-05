import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class RowLikeWidget extends StatefulWidget {
  final ArticleDetail articleDetail;
  RowLikeWidget({this.articleDetail});

  @override
  _RowLikeWidgetState createState() => _RowLikeWidgetState();
}

class _RowLikeWidgetState extends State<RowLikeWidget> {
  ArticleDetail _articleDetail;
  @override
  void initState() {
    _articleDetail = widget.articleDetail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_articleDetail.isLike == 0) {
          likeArticle();
        } else {
          unLikedArticle();
        }
      },
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            'images/ic_like_full.svg',
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

  likeArticle() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
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
    final provider = Provider.of<HomeProvider>(context, listen: false);
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
