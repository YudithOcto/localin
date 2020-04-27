import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localin/components/user_profile_box_widget.dart';
import 'package:localin/presentation/profile/revamp/page/user_profile/revamp_edit_profile_page.dart';
import 'package:localin/presentation/profile/revamp/page/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/presentation/profile/revamp/page/user_profile/row_profile_settings_widget.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/profile/user_profile_detail_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

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
      Provider.of<UserProfileProvider>(context, listen: false)
          .getUserDanaStatus();
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
                      '0 points',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0 - NavigationToolbar.kMiddleSpacing),
              child: Row(
                children: <Widget>[
                  Consumer<AuthProvider>(builder: (context, provider, child) {
                    return Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        UserProfileBoxWidget(
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: StreamBuilder<danaStatus>(
                  stream:
                      Provider.of<UserProfileProvider>(context, listen: false)
                          .danaAccountStream,
                  builder: (context, snapshot) {
                    final profileProvider =
                        Provider.of<UserProfileProvider>(context);
                    return RowProfileSettingsWidget(
                      title: 'Dana',
                      description: 'Payment Method',
                      iconValue: 'images/profile_dana.svg',
                      showButton: profileProvider?.userDanaAccount?.data !=
                              null &&
                          profileProvider?.userDanaAccount?.data?.maskDanaId !=
                              null,
                      onPressed: () {
                        _connectAccountToDana(profileProvider);
                      },
                    );
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: RowProfileSettingsWidget(
                title: 'Point',
                description: 'Learn how to get local point',
                iconValue: 'images/profile_point.svg',
                showButton: false,
                onPressed: () {},
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: RowProfileSettingsWidget(
                title: 'About',
                description: 'General Information about Localin',
                iconValue: 'images/profile_about.svg',
                showButton: false,
                onPressed: () {
                  Navigator.of(context).pushNamed(WebViewPage.routeName,
                      arguments: {WebViewPage.urlName: 'https://localin.id'});
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: RowProfileSettingsWidget(
                title: 'Privacy Policy',
                description: 'Read user agreements',
                iconValue: 'images/profile_privacy_policy.svg',
                showButton: false,
                onPressed: () {
                  Navigator.of(context).pushNamed(WebViewPage.routeName,
                      arguments: {
                        WebViewPage.urlName:
                            'https://localin.id/privacy-policy.html'
                      });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return RowProfileSettingsWidget(
                    title: 'Verification',
                    description: 'Verify your account',
                    iconValue: 'images/profile_verification.svg',
                    showButton:
                        provider.userModel.status != kUserStatusVerified,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(RevampUserVerificationPage.routeName);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _connectAccountToDana(UserProfileProvider provider) async {
    final authState = Provider.of<AuthProvider>(context, listen: false);
    if (authState.userModel.handphone != null &&
        authState.userModel.handphone.isNotEmpty) {
      final result = await provider
          .authenticateUserDanaAccount(authState.userModel.handphone);
      if (result.urlRedirect.isNotEmpty && !result.error) {
        final response = await Navigator.of(context).pushNamed(
            WebViewPage.routeName,
            arguments: {WebViewPage.urlName: result.urlRedirect});
        if (response != null && response == 'success') {
          final dialogResult = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('DANA'),
                  content: Text(
                    'Connect to dana success',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: ThemeColors.primaryBlue,
                      onPressed: () => Navigator.of(context).pop('success'),
                      child: Text(
                        'Ok',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                );
              });

          if (dialogResult == 'success') {
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
