import 'package:flutter/material.dart';
import 'package:localin/components/circle_image.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/presentation/news/widgets/comments/parent_comment_card.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class CommunityMyGroupLatestPost extends StatelessWidget {
  final CommunityComment singlePost;
  CommunityMyGroupLatestPost({this.singlePost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      width: double.maxFinite,
      color: ThemeColors.black0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomImageRadius(
                imageUrl: singlePost.communityLogo ?? '',
                radius: 8.0,
                width: 48.0,
                height: 48.0,
              ),
              SizedBox(
                width: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${singlePost.communityCategoryName} • ${singlePost.communityTotalMember} members',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80),
                  ),
                  Text(
                    '${singlePost.communityName}',
                    style: ThemeText.rodinaTitle3,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16.0,
            child: DashedLine(
              color: ThemeColors.black20,
              height: 1.5,
            ),
          ),
          Text(
            'LATEST POST',
            style: ThemeText.sfSemiBoldCaption
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            '${singlePost.commentContent.replaceAll('<br />', '\n')}',
            style: ThemeText.sfRegularBody,
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: <Widget>[
              CircleImage(
                imageUrl: '${singlePost.createdAvatar ?? ''}',
                width: 32.0,
                height: 32.0,
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Text(
                  '${singlePost.createdName}',
                  style: ThemeText.sfMediumBody
                      .copyWith(color: ThemeColors.primaryBlue),
                ),
              ),
              Text(
                '${DateHelper.timeAgo(DateTime.parse(singlePost.createdAt))}',
                style: ThemeText.sfMediumFootnote
                    .copyWith(color: ThemeColors.black80),
              )
            ],
          )
        ],
      ),
    );
  }
}
