import 'package:flutter/material.dart';
import 'package:localin/build_environment.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/presentation/profile/user_profile/provider/user_profile_detail_provider.dart';
import 'package:localin/presentation/profile/user_profile/widgets/row_profile_settings_widget.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/presentation/webview/revamp_webview.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../../themes.dart';

class ProfileSettingsWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: StreamBuilder<danaStatus>(
              stream: Provider.of<UserProfileProvider>(context, listen: false)
                  .danaAccountStream,
              builder: (context, snapshot) {
                final profileProvider =
                    Provider.of<UserProfileProvider>(context);
                return RowProfileSettingsWidget(
                  title: 'Dana',
                  description: 'Payment Method',
                  iconValue: 'images/profile_dana.svg',
                  showButton: profileProvider?.userDanaAccount?.data == null ||
                      profileProvider?.userDanaAccount?.data?.maskDanaId ==
                          null,
                  onPressed: () {
                    _connectAccountToDana(context);
                  },
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: RowProfileSettingsWidget(
            title: 'Point',
            description: 'Learn how to get local point',
            iconValue: 'images/profile_point.svg',
            showButton: false,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(RevampWebview.routeName, arguments: {
                RevampWebview.url: '${buildEnvironment.baseUrl}#point',
                RevampWebview.isFromProfile: true,
                RevampWebview.title: 'Point',
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: RowProfileSettingsWidget(
            title: 'About',
            description: 'General Information about Localin',
            iconValue: 'images/profile_about.svg',
            showButton: false,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(RevampWebview.routeName, arguments: {
                RevampWebview.url: '${buildEnvironment.baseUrl}',
                RevampWebview.isFromProfile: true,
                RevampWebview.title: 'About',
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: RowProfileSettingsWidget(
            title: 'Privacy Policy',
            description: 'Read user agreements',
            iconValue: 'images/profile_privacy_policy.svg',
            showButton: false,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(RevampWebview.routeName, arguments: {
                RevampWebview.url:
                    '${buildEnvironment.baseUrl}privacy-policy.html',
                RevampWebview.isFromProfile: true,
                RevampWebview.title: 'Privacy Policy',
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return RowProfileSettingsWidget(
                title: 'Verification',
                description: 'Verify your account',
                iconValue: 'images/profile_verification.svg',
                showButton: provider.userModel.status != kUserStatusVerified,
                onPressed: () async {
                  Navigator.of(context)
                      .pushNamed(RevampUserVerificationPage.routeName);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  _connectAccountToDana(BuildContext context) async {
    final result =
        await Provider.of<HomeProvider>(context, listen: false).getDanaStatus();
    if (result.error == null) {
      await Navigator.of(context).pushNamed(WebViewPage.routeName, arguments: {
        WebViewPage.urlName: result.data.urlTopUp,
        WebViewPage.title: 'Dana',
      });
    } else {
      final authState = Provider.of<AuthProvider>(context, listen: false);
      if (authState.userModel.handphone != null &&
          authState.userModel.handphone.isNotEmpty) {
        final result = await authState
            .authenticateUserDanaAccount(authState.userModel.handphone);
        if (result.urlRedirect.isNotEmpty && !result.error) {
          final response = await Navigator.of(context)
              .pushNamed(WebViewPage.routeName, arguments: {
            WebViewPage.urlName: result.urlRedirect,
            WebViewPage.title: 'Dana',
          });
          if (response != null && response == 'success') {
            final dialogSuccess = await CustomDialog.showCustomDialogWithButton(
                context, 'Dana', 'Connect to dana success');

            if (dialogSuccess == 'success') {
              Provider.of<UserProfileProvider>(context).getUserDanaStatus();
            }
          }
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('No Phone number on your account'),
          duration: Duration(milliseconds: 1500),
        ));
      }
    }
  }
}
