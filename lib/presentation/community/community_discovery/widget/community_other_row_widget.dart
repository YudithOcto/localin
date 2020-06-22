import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CommunityOtherRowWidget extends StatelessWidget {
  final CommunityDetail detail;
  CommunityOtherRowWidget({@required this.detail});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CommunityDetailPage.routeName, arguments: {
          CommunityDetailPage.communitySlug: detail.slug,
        });
      },
      child: Container(
        color: ThemeColors.black0,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            CustomImageRadius(
              height: 80.0,
              width: 80.0,
              radius: 8.0,
              imageUrl: detail.logoUrl ?? '',
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${detail.categoryName}'.toUpperCase(),
                    style: ThemeText.sfSemiBoldFootnote
                        .copyWith(color: ThemeColors.black80),
                  ),
                  Text(
                    '${detail?.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeText.rodinaHeadline,
                  ),
                  Text(
                    '${detail?.totalMember} members',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80),
                  )
                ],
              ),
            ),
            Visibility(
              visible: !detail.isJoin,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: ThemeColors.black20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: Text(
                    'Join',
                    style: ThemeText.rodinaHeadline
                        .copyWith(color: ThemeColors.primaryBlue),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
