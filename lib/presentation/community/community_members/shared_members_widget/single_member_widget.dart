import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/model/community/community_member_detail.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/date_helper.dart';

class SingleMemberWidget extends StatelessWidget {
  final CommunityMemberDetail detail;
  final bool isGroupCreator;
  final List<String> popupItem;
  final Function(Map<String, CommunityMemberDetail>) onPopupClick;

  SingleMemberWidget({
    @required this.detail,
    this.popupItem,
    this.onPopupClick,
    @required this.isGroupCreator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            UserProfileImageWidget(
              imageUrl: '${detail?.imageProfile ?? ''}',
            ),
            Positioned(
              right: -4.0,
              bottom: -4.0,
              child: Visibility(
                visible: detail?.isVerified ?? false,
                child: SvgPicture.asset(
                  'images/verified_profile.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${detail?.name ?? ''}',
                  style: ThemeText.rodinaTitle3
                      .copyWith(color: ThemeColors.primaryBlue)),
              Text(
                '${isGroupCreator ? 'Created this group' : 'Added by ${detail.addedBy}'} ${DateHelper.timeAgo(DateTime.parse(detail.joinedDate)) ?? ''}',
                style: ThemeText.sfRegularFootnote
                    .copyWith(color: ThemeColors.black80),
              ),
            ],
          ),
        ),
        Visibility(
          visible: popupItem != null,
          child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: ThemeColors.black100,
              ),
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              onSelected: (v) {
                Map<String, CommunityMemberDetail> map = Map();
                map[v] = detail;
                onPopupClick(map);
              },
              itemBuilder: (context) {
                return popupItem
                    .map((e) => PopupMenuItem(
                          value: e,
                          child: Text('$e'),
                        ))
                    .toList();
              }),
        ),
      ],
    );
  }
}
