import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/presentation/profile/user_profile/provider/user_profile_detail_provider.dart';
import 'package:localin/presentation/profile/user_profile/revamp_edit_profile_page.dart';
import 'package:localin/presentation/profile/user_profile/widgets/profile_settings_widgets.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';

class RevampProfilePage extends StatelessWidget {
  static const routeName = '/revampProfilePage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProfileProvider>(
      create: (_) => UserProfileProvider(),
      child: RevampProfileContentWidget(),
    );
  }
}

class RevampProfileContentWidget extends StatefulWidget {
  @override
  _RevampProfileContentWidgetState createState() =>
      _RevampProfileContentWidgetState();
}

class _RevampProfileContentWidgetState
    extends State<RevampProfileContentWidget> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final provider = Provider.of<UserProfileProvider>(context, listen: false);
      provider.getUserDanaStatus();
      provider.getUserProfile().then((value) {
        Provider.of<AuthProvider>(context, listen: false)
            .updateUserIdentityVerification(value);
      });
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeColors.black0,
        title: Padding(
          padding: const EdgeInsets.only(
              left: 20.0 - NavigationToolbar.kMiddleSpacing,
              top: 25.0 - NavigationToolbar.kMiddleSpacing),
          child: Text(
            'Profile',
            style:
                ThemeText.rodinaTitle1.copyWith(color: ThemeColors.brandBlack),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                right: 20.0, top: 25.0 - NavigationToolbar.kMiddleSpacing),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Row(
                  children: <Widget>[
                    Text(
                      '${authProvider.userModel.points} points',
                      style: ThemeText.sfSemiBoldBody,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    SvgPicture.asset('images/profile_points.svg')
                  ],
                );
              },
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 16.0),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0 - NavigationToolbar.kMiddleSpacing),
                  child: Row(
                    children: <Widget>[
                      Consumer<AuthProvider>(
                          builder: (context, provider, child) {
                        return Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            UserProfileImageWidget(
                              imageUrl: provider.userModel.imageProfile,
                            ),
                            Positioned(
                              right: -4.0,
                              bottom: -4.0,
                              child: Visibility(
                                visible: provider.userModel.status ==
                                    kUserStatusVerified,
                                child: SvgPicture.asset(
                                  'images/verified_profile.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Consumer<AuthProvider>(
                          builder: (context, provider, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${provider.userModel.username}',
                                  style: ThemeText.rodinaTitle3
                                      .copyWith(color: ThemeColors.primaryBlue),
                                ),
                                Text(
                                  '${provider.userModel.email}',
                                  style: ThemeText.sfRegularBody,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: ThemeColors.black20)),
                        child: InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(RevampEditProfilePage.routeName),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Edit',
                              style: ThemeText.sfMediumFootnote
                                  .copyWith(color: ThemeColors.primaryBlue),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    'About',
                    style: ThemeText.sfSemiBoldBody,
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Text(
                        '${provider.userModel.shortBio ?? 'No Data Yet'}',
                        style: ThemeText.sfRegularBody,
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 24.0),
                  child: Divider(
                    thickness: 1.5,
                    color: ThemeColors.black20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 4.0),
                  child: Text(
                    'Settings',
                    style: ThemeText.sfSemiBoldBody
                        .copyWith(color: ThemeColors.black80),
                  ),
                ),
                ProfileSettingsWidgets(),
              ],
            ),
          ),
          InkWell(
            onTap: () => signOut(),
            child: Container(
              height: 56.0,
              width: double.maxFinite,
              alignment: Alignment.center,
              color: ThemeColors.black10,
              child: Text(
                'Logout',
                textAlign: TextAlign.center,
                style: ThemeText.sfMediumBody.copyWith(color: ThemeColors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  signOut() async {
    final authState = Provider.of<AuthProvider>(context, listen: false);
    final logout = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Logout',
                  style: ThemeText.sfMediumTitle3,
                ),
                SizedBox(height: 8.0),
                Text('Are you sure you want to log out',
                    style: ThemeText.sfMediumBody
                        .copyWith(color: ThemeColors.black80)),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        elevation: 1.0,
                        onPressed: () => Navigator.of(context).pop(),
                        color: ThemeColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          'No',
                          style: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        elevation: 1.0,
                        color: ThemeColors.black0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(
                              color: ThemeColors.primaryBlue,
                            )),
                        onPressed: () => Navigator.of(context).pop('success'),
                        child: Text(
                          'Yes',
                          style: ThemeText.rodinaTitle3
                              .copyWith(color: ThemeColors.primaryBlue),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
    if (logout != null && logout == 'success') {
      if (authState.userModel.source == 'facebook.com') {
        final result = await authState.signOutFacebook();
        if (result == 'Success logout') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName, (Route<dynamic> route) => false);
        } else {
          CustomToast.showCustomToast(context, result);
        }
      } else {
        final result = await authState.signOutGoogle();
        if (result.contains('Success logout')) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginPage.routeName, (Route<dynamic> route) => false);
        } else {
          CustomToast.showCustomToast(context, result);
        }
      }
    }
  }
}
