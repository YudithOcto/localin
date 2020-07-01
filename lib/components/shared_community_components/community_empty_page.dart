import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localin/components/outline_button_default.dart';
import 'package:localin/presentation/community/community_create/community_create_page.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../text_themes.dart';
import '../../themes.dart';
import '../custom_dialog.dart';

class CommunityEmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 48.0, right: 48.0),
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'images/empty_community.svg',
          ),
          Text(
            'Can\'t find community around me',
            textAlign: TextAlign.center,
            style: ThemeText.sfSemiBoldHeadline
                .copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Dicover community from other location, or create your own community',
            textAlign: TextAlign.center,
            style: ThemeText.sfRegularBody.copyWith(color: ThemeColors.black80),
          ),
          SizedBox(
            height: 16.0,
          ),
          OutlineButtonDefault(
            onPressed: () async {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              if (auth.userModel.status == kUserStatusVerified) {
                Navigator.of(context).pushNamed(CommunityCreatePage.routeName);
              } else {
                CustomDialog.showCustomDialogWithMultipleButton(context,
                    title: 'Create Community',
                    message:
                        'Your Account Has Not Been Verified, Please Verify Your Account',
                    cancelText: 'Close',
                    onCancel: () => Navigator.of(context).pop(),
                    okText: 'Verified',
                    okCallback: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(RevampUserVerificationPage.routeName);
                    });
              }
            },
            buttonText: 'Create my own community',
          )
        ],
      ),
    );
  }
}
