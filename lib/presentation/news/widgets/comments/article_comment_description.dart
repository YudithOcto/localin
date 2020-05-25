import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/news/shared_widget/mini_user_public_profile.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class ArticleCommentDescription extends StatelessWidget {
  final ArticleDetail _articleDetail;
  ArticleCommentDescription({ArticleDetail detail})
      : assert(detail != null),
        _articleDetail = detail;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 99.0,
      color: ThemeColors.yellow10,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomImageRadius(
            height: 85.0,
            width: 70.0,
            placeHolderColor: ThemeColors.black0,
            radius: 8.0,
            imageUrl: _articleDetail.image.isNotEmpty
                ? _articleDetail.image.first.attachment
                : null,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${_articleDetail.title ?? 'local news'}',
                  style: ThemeText.rodinaHeadline,
                ),
                SizedBox(
                  height: 6.0,
                ),
                MiniUserPublicProfile(
                  articleDetail: _articleDetail,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
