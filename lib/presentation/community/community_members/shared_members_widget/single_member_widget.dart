import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/filled_button_default.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/model/community/community_member_detail.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/community_member_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class SingleMemberWidget extends StatelessWidget {
  final CommunityMemberDetail detail;
  final List<String> popupItem;
  final bool isRequestPage;
  final String rowDescription;
  final Function onRefresh;
  final bool isAdminUser;

  // for admin tab only, other than that give false
  final bool isOnlyAdminTab;

  SingleMemberWidget({
    @required this.detail,
    this.popupItem,
    this.isRequestPage = false,
    @required this.rowDescription,
    @required this.onRefresh,
    @required this.isOnlyAdminTab,
    @required this.isAdminUser,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RevampOthersProfilePage.routeName,
            arguments: {RevampOthersProfilePage.userId: detail.id});
      },
      child: Row(
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
                  '$rowDescription',
                  style: ThemeText.sfRegularFootnote
                      .copyWith(color: ThemeColors.black80),
                ),
                Visibility(
                    visible: isRequestPage, child: SizedBox(height: 10.0)),
                Visibility(
                  visible: isRequestPage,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlineButtonDefault(
                          height: 24.0,
                          buttonText: kPopupApproveMember.toUpperCase(),
                          textStyle: ThemeText.sfMediumFootnote,
                          onPressed: () =>
                              onPopupPressed(context, kPopupApproveMember),
                        ),
                      ),
                      SizedBox(
                        width: 8.5,
                      ),
                      Expanded(
                        child: OutlineButtonDefault(
                          height: 24.0,
                          sideColor: ThemeColors.black60,
                          textColor: ThemeColors.black80,
                          textStyle: ThemeText.sfMediumFootnote,
                          buttonText: kPopupDeclineMember.toUpperCase(),
                          onPressed: () =>
                              onPopupPressed(context, kPopupApproveMember),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: popupItem != null && isAdminUser,
            child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: ThemeColors.black100,
                ),
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                onSelected: (String value) => onPopupPressed(context, value),
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
      ),
    );
  }

  List<Widget> getButtonWidget(BuildContext context,
      {String resultDialogTitle, String status}) {
    final provider =
        Provider.of<CommunityMemberProvider>(context, listen: false);
    List<Widget> widget = List();
    widget.add(FilledButtonDefault(
      buttonText: 'OK',
      onPressed: () async {
        Navigator.of(context).pop();
        CustomDialog.showLoadingDialog(context, message: 'Please wait');
        final result = await provider.moderateSingleMember(
            status: status, memberId: detail.id);
        CustomDialog.closeDialog(context);
        if (result.error == null) {
          final dialog = await CustomDialog.showCustomDialogWithButton(
              context, '$resultDialogTitle', result?.message);
          if (dialog == 'success') {
            onRefresh();
          }
        } else {
          CustomDialog.showCustomDialogWithButton(
              context, '$resultDialogTitle', result?.message);
        }
      },
      backgroundColor: ThemeColors.primaryBlue,
      textTheme: ThemeText.rodinaHeadline.copyWith(color: ThemeColors.black0),
    ));
    widget.add(InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        alignment: FractionalOffset.center,
        child: Text(
          'Cancel',
          style: ThemeText.rodinaHeadline.copyWith(color: ThemeColors.black80),
        ),
      ),
    ));
    return widget;
  }

  onPopupPressed(BuildContext context, String value) async {
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false).userModel;
    bool isSelfAdmin = authProvider.id == detail.id;
    switch (value) {
      case kPopupMakeAdmin:
        if (isSelfAdmin) {
          CustomDialog.showCustomDialogWithButton(
              context, 'Admin', 'You already an admin of this group',
              btnText: 'Close');
          return;
        }
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Invite ${detail.name} to be a group admin',
            message:
                '${detail.name} will be able to edit group settings, remove members & give other members admin status.',
            dialogButtons: getButtonWidget(context,
                resultDialogTitle: 'Admin', status: kAdminStatus));
        break;
      case kPopupRemoveAdmin:
        if (isOnlyAdminTab) {
          CustomDialog.showCustomDialogWithButton(context, 'Blocked',
              'You cannot remove yourself or remove the only member',
              btnText: 'Close');
          return;
        }
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Remove ${detail.name} as group admin',
            message:
                '${detail.name} will not able to edit group settings, remove members & give other members admin status.',
            dialogButtons: getButtonWidget(context,
                resultDialogTitle: 'Admin', status: kRemoveAdminStatus));
        break;
      case kPopupRemoveMember:
        if (isSelfAdmin) {
          CustomDialog.showCustomDialogWithButton(context, 'Blocked',
              'You cannot remove yourself or remove the only member',
              btnText: 'Close');
          return;
        }
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Remove ${detail.name} from this group',
            message:
                'Are you sure you want to remove ${detail.name} from this group?',
            dialogButtons: getButtonWidget(context,
                resultDialogTitle: 'Remove Member',
                status: kRemoveMemberStatus));
        break;
      case kPopupViewProfile:
        Navigator.of(context)
            .pushNamed(RevampOthersProfilePage.routeName, arguments: {
          RevampOthersProfilePage.userId: detail.id,
        });
        break;
      case kPopupBlock:
        if (isOnlyAdminTab || isSelfAdmin) {
          CustomDialog.showCustomDialogWithButton(context, 'Blocked',
              'You cannot block yourself or block the only member',
              btnText: 'Close');
          return;
        }
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Block ${detail.name} from this group',
            message:
                '${detail.name} won’t be able to find, see or join this group.',
            dialogButtons: getButtonWidget(context,
                resultDialogTitle: 'Block Member', status: kBlockedStatus));
        break;
      case kPopupRemoveBlock:
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Unblock ${detail.name} from this group',
            message:
                '${detail.name} will be able to find, see or join this group.',
            dialogButtons: getButtonWidget(context,
                resultDialogTitle: 'Unblock', status: kUnblockStatus));
        break;
      case kPopupApproveMember:
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Accept ${detail.name} from this group',
            message: '${detail.name} will be able to see this group activity'
                '',
            dialogButtons: getButtonWidget(context,
                resultDialogTitle: 'Request', status: kApproveStatus));
        break;
      case kPopupDeclineMember:
        CustomDialog.showCustomDialogVerticalMultipleButton(context,
            title: 'Decline ${detail.name} to join this group',
            message: '${detail.name} rejected to join this group',
            dialogButtons: getButtonWidget(context,
                resultDialogTitle: 'Request', status: kDeclineStatus));
        break;
    }
  }
}
