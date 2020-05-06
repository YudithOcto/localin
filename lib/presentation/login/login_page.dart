import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/components/custom_dialog.dart';
import 'package:localin/components/custom_toast.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'input_phone_number_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginpage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    FirebaseMessaging().getToken().then((token) {
      sf.setString('tokenFirebase', token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Content(),
        padding: EdgeInsets.only(bottom: 20.0),
      ),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FadeAnimation(
              delay: 0.2,
              fadeDirection: FadeDirection.bottom,
              child: Image.asset(
                'images/login_cover.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Join to discover your city by join community, event, find a local stay and food.',
                  style: ThemeText.sfRegularHeadline
                      .copyWith(color: ThemeColors.black80),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 20.0,
            ),
            FadeAnimation(
              delay: 0.3,
              fadeDirection: FadeDirection.top,
              child: Container(
                height: 60.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 2.0,
                  onPressed: () => thirdPartySignIn(context, isFacebook: true),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  color: ThemeColors.facebookColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0.0,
                        top: 5.0,
                        bottom: 5.0,
                        child: Image.asset(
                          'images/facebook.png',
                          width: 56,
                          height: 44,
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Text(
                          'Login with Facebook',
                          textAlign: TextAlign.center,
                          style: ThemeText.rodinaHeadline
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            FadeAnimation(
              fadeDirection: FadeDirection.top,
              delay: 0.3,
              child: Container(
                height: 60.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 2.0,
                  onPressed: () => thirdPartySignIn(context, isFacebook: false),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  color: ThemeColors.googleColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0.0,
                        top: 5.0,
                        bottom: 5.0,
                        child: Image.asset(
                          'images/google.png',
                          width: 56,
                          height: 44,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Text(
                          'Login with Google',
                          textAlign: TextAlign.center,
                          style: ThemeText.rodinaHeadline
                              .copyWith(color: ThemeColors.black0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: 'By continuing, you agree to our',
                  style: ThemeText.sfMediumCaption
                      .copyWith(color: ThemeColors.black80),
                ),
                TextSpan(
                    text: ' Terms of Service',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final response = await Navigator.of(context)
                            .pushNamed(WebViewPage.routeName, arguments: {
                          WebViewPage.urlName:
                              'https://localin.id/privacy-policy.html',
                          WebViewPage.title: 'Dana',
                        });
                      },
                    style: ThemeText.sfMediumCaption
                        .copyWith(color: ThemeColors.primaryBlue)),
              ]),
            )
          ],
        ),
      ],
    );
  }

  openPhoneVerificationPage(BuildContext context, String phone) {
    Navigator.of(context).pushReplacementNamed(InputPhoneNumberPage.routeName,
        arguments: {InputPhoneNumberPage.userPhoneVerificationCode: phone});
  }

  openInputPhoneNumberPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(InputPhoneNumberPage.routeName,
        arguments: {InputPhoneNumberPage.userPhoneVerificationCode: ''});
  }

  thirdPartySignIn(BuildContext context, {bool isFacebook = false}) async {
    CustomDialog.showLoadingDialog(context);
    final authState = Provider.of<AuthProvider>(context, listen: false);
    final result = isFacebook
        ? await authState.signInWithFacebook()
        : await authState.signInWithGoogle();
    if (authState.errorMessage.isError) {
      CustomDialog.closeDialog(context);
      CustomToast.showCustomToast(context, authState.errorMessage);
    } else {
      if (result.handphone.isNotNullOrNotEmpty) {
        openPhoneVerificationPage(context, result.handphone);
      } else {
        openInputPhoneNumberPage(context);
      }
    }
  }
}

extension on String {
  bool get isError {
    ///because result not null and error field is empty
    return this != null && this.isNotEmpty;
  }

  bool get isNotNullOrNotEmpty {
    return this != null && this.isNotEmpty;
  }
}
