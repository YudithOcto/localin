import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/model/article/article_detail.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class MiniUserPublicProfile extends StatelessWidget {
  final ArticleDetail _articleDetail;

  MiniUserPublicProfile({@required ArticleDetail articleDetail})
      : assert(articleDetail != null),
        _articleDetail = articleDetail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RevampOthersProfilePage.routeName, arguments: {
          RevampOthersProfilePage.userId: _articleDetail?.createdBy,
        });
      },
      child: Row(
        children: <Widget>[
          CircleImage(
            imageUrl: _articleDetail?.authorImage,
          ),
          SizedBox(
            width: 8.0,
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'by ',
                  style: ThemeText.sfMediumBody
                      .copyWith(color: ThemeColors.black80)),
              TextSpan(
                  text: '${_articleDetail?.author ?? '-'}',
                  style: ThemeText.sfMediumBody
                      .copyWith(color: ThemeColors.primaryBlue)),
            ]),
          )
        ],
      ),
    );
  }
}
