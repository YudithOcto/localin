import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_event/community_event_page.dart';
import 'package:localin/presentation/community/community_members/community_members_page.dart';
import 'package:localin/presentation/community/community_detail/provider/community_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';

class CommunitySettingsWidget extends StatelessWidget {
  final bool isAdmin;
  final CommunityDetail communityDetail;
  final CommunityDetailProvider provider;
  CommunitySettingsWidget(
      {@required this.isAdmin, @required this.communityDetail, this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Visibility(
          visible: isAdmin,
          child: InkWell(
            onTap: () {},
            child: RowSettings(
              icon: 'images/community_settings.svg',
              title: 'Group Settings',
            ),
          ),
        ),
        Visibility(
          visible: isAdmin,
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(CommunityMembersPage.routeName, arguments: {
                CommunityMembersPage.communityId: communityDetail.id,
              });
            },
            child: RowSettings(
              icon: 'images/community_settings_member.svg',
              title: 'Members',
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(CommunityEventPage.routeName, arguments: {
              CommunityEventPage.communityId: communityDetail.id,
            });
          },
          child: RowSettings(
            icon: 'images/community_settings_promo.svg',
            title: 'Events',
          ),
        ),
        InkWell(
          onTap: () async {
            final canLogout =
                await provider.getAdmin(communityId: communityDetail.id);
            if (canLogout) {
              CustomDialog.showLoadingDialog(context, message: 'Loading . . .');
              final response =
                  await provider.leaveCommunity(communityDetail.id);
              CustomDialog.closeDialog(context);
              final result = await CustomDialog.showCustomDialogWithButton(
                  context, 'Leave Community', '${response.message ?? ''}',
                  btnText: 'Close');
              if (result == 'success') {
                Navigator.of(context).pop();
              }
            } else {
              CustomDialog.showCustomDialogWithButton(
                  context,
                  'Leave Community',
                  'You are able to leave community if there are others admin',
                  btnText: 'Close');
            }
          },
          child: RowSettings(
            icon: 'images/community_settings_exit.svg',
            title: 'Leave',
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            alignment: FractionalOffset.center,
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration:
                BoxDecoration(border: Border.all(color: ThemeColors.black20)),
            child: Text(
              'Close',
              textAlign: TextAlign.center,
              style:
                  ThemeText.rodinaTitle3.copyWith(color: ThemeColors.black80),
            ),
          ),
        ),
      ],
    );
  }
}

class RowSettings extends StatelessWidget {
  final String icon;
  final String title;
  final Color colors;

  RowSettings({this.icon, this.title, this.colors = ThemeColors.black100});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(icon, fit: BoxFit.cover),
          SizedBox(width: 17.0),
          Text(
            title,
            style: ThemeText.sfMediumBody.copyWith(color: colors),
          )
        ],
      ),
    );
  }
}
