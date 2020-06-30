import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/model/community/community_event_member_response.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class CommunityMemberWidget extends StatelessWidget {
  final EventMemberDetail detail;
  CommunityMemberWidget({this.detail});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: <Widget>[
          UserProfileImageWidget(
            imageUrl: '${detail?.memberImage ?? ''}',
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${detail?.memberName ?? ''}',
                    style: ThemeText.rodinaTitle3
                        .copyWith(color: ThemeColors.primaryBlue)),
                Text(
                  '${DateHelper.timeAgo(detail?.joinDate)}',
                  style: ThemeText.sfRegularFootnote
                      .copyWith(color: ThemeColors.black80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
