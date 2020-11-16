import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/model/community/community_detail.dart';
import 'package:localin/presentation/community/community_create/community_create_page.dart';
import 'package:localin/presentation/community/community_detail/provider/community_detail_provider.dart';
import 'package:localin/presentation/community/community_event/community_event_tab_list_page.dart';
import 'package:localin/presentation/community/community_members/community_members_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';

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
            onTap: () async {
              Navigator.of(context).pop();
              final result = await Navigator.of(context)
                  .pushNamed(CommunityCreatePage.routeName, arguments: {
                CommunityCreatePage.previousCommunityData: communityDetail
              });
              if (result != null) {
                provider.getCommunityDetail(communityDetail.slug);
              }
            },
            child: RowSettings(
              icon: 'images/community_settings.svg',
              title: 'Group Settings',
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(CommunityMembersPage.routeName, arguments: {
              CommunityMembersPage.communityId: communityDetail.id,
              CommunityMembersPage.isAdmin: communityDetail.isAdmin,
            });
          },
          child: RowSettings(
            icon: 'images/community_settings_member.svg',
            title: 'Members',
          ),
        ),
        InkWell(
          onTap: () {
            if (provider.communityDetail.features.event) {
              Navigator.of(context)
                  .pushNamed(CommunityEventTabListPage.routeName, arguments: {
                CommunityEventTabListPage.communityId: communityDetail,
              });
            } else {
              CustomDialog.showCustomDialogWithButton(context, 'Event',
                  'You need to upgrade to pro community to use this feature.',
                  btnText: 'Close');
            }
          },
          child: RowSettings(
            icon: 'images/community_settings_promo.svg',
            title: 'Events',
          ),
        ),
        Visibility(
          visible: communityDetail.communityType != kFreeCommunity,
          child: InkResponse(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0))),
                  builder: (ctx) => Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('${communityDetail?.couponCode ?? ''}',
                                style: ThemeText.sfSemiBoldTitle3
                                    .copyWith(color: ThemeColors.red)),
                            SizedBox(height: 31.0),
                            Text(kCouponCodeMessage,
                                textAlign: TextAlign.center,
                                style: ThemeText.sfRegularBody
                                    .copyWith(color: ThemeColors.black80)),
                            SizedBox(height: 27.0),
                            FilledButtonDefault(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text:
                                        '${communityDetail?.couponCode ?? ''}'));
                                CustomToast.showCustomToastWhite(
                                    context, 'Coupon code copied.');
                              },
                              textTheme: ThemeText.rodinaTitle3
                                  .copyWith(color: ThemeColors.black0),
                              backgroundColor: ThemeColors.primaryBlue,
                              buttonText: 'Copy Code',
                            ),
                            SizedBox(height: 27.0),
                            OutlineButtonDefault(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              buttonText: 'Close',
                              sideColor: ThemeColors.black20,
                            )
                          ],
                        ),
                      ));
            },
            child: RowSettings(
              icon: 'images/icon_coupon_code.svg',
              title: 'Coupon Code',
            ),
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
