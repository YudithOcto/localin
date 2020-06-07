import 'package:flutter/material.dart';
import 'package:localin/components/custom_image_radius.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CommunityMyGroupOtherCommunities extends StatelessWidget {
  final CommunityDetail communityDetail;
  CommunityMyGroupOtherCommunities({this.communityDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.black0,
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          CustomImageRadius(
            width: 80.0,
            height: 80.0,
            radius: 8.0,
            imageUrl: communityDetail.logoUrl ?? '',
          ),
          SizedBox(
            width: 16.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${communityDetail.categoryName}',
                style: ThemeText.sfSemiBoldFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
              Text(
                '${communityDetail.name}',
                style: ThemeText.rodinaHeadline,
              ),
              Text(
                '${communityDetail.totalMember ?? 0} members',
                style:
                    ThemeText.sfMediumBody.copyWith(color: ThemeColors.black80),
              )
            ],
          )
        ],
      ),
    );
  }
}
