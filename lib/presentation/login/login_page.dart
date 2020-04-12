import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/login/phone_verification_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
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
      body: Content(),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthProvider>(context);
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Column(
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
                  onPressed: () async {
                    SharedPreferences sf =
                        await SharedPreferences.getInstance();
                    final result = await authState
                        .signInWithFacebook(sf.getString('tokenFirebase'));
                    if (result != null &&
                        authState.errorMessage != null &&
                        authState.errorMessage.isEmpty) {
                      final save = await SharedPreferences.getInstance();
                      save.setBool(kUserVerify, false);
                      if (result.handphone != null &&
                          result.handphone.isNotEmpty) {
                        Navigator.of(context).pushNamed(
                            PhoneVerificationPage.routeName,
                            arguments: {
                              PhoneVerificationPage.phone: result.handphone,
                              PhoneVerificationPage.isBackButtonActive: false,
                            });
                      } else {
                        Navigator.of(context).pushNamed(
                            InputPhoneNumberPage.routeName,
                            arguments: {
                              InputPhoneNumberPage.openVerificationCode: false
                            });
                      }
                    } else {
                      showErrorMessageDialog(context, authState.errorMessage);
                    }
                  },
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
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              content: Row(
                                children: <Widget>[
                                  Container(
                                      width: 36.0,
                                      height: 36.0,
                                      child: CircularProgressIndicator()),
                                  SizedBox(
                                    width: 17.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                        'Signing you in and loading your data',
                                        style: ThemeText.sfMediumBody.copyWith(
                                            color: ThemeColors.black80)),
                                  ),
                                ],
                              ),
                            ));

                    SharedPreferences sf =
                        await SharedPreferences.getInstance();
                    final result = await authState
                        .signInWithGoogle(sf.getString('tokenFirebase'));
                    if (result != null) {
                      Navigator.of(context, rootNavigator: true).pop();
                      if (authState.errorMessage.isNotEmpty) {
                        showErrorMessageDialog(context, authState.errorMessage);
                      } else {
                        final save = await SharedPreferences.getInstance();
                        save.setBool(kUserVerify, false);
                        if (result.handphone != null &&
                            result.handphone.isNotEmpty) {
                          Navigator.of(context).pushNamed(
                              PhoneVerificationPage.routeName,
                              arguments: {
                                PhoneVerificationPage.phone: result.handphone,
                                PhoneVerificationPage.isBackButtonActive: false,
                              });
                        } else {
                          Navigator.of(context).pushNamed(
                              InputPhoneNumberPage.routeName,
                              arguments: {
                                InputPhoneNumberPage.openVerificationCode:
                                    false,
                              });
                        }
                      }
                    }
                    //
                  },
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
                    style: ThemeText.sfMediumCaption
                        .copyWith(color: ThemeColors.primaryBlue)),
              ]),
            )
          ],
        ),
//        Center(
//          child: Visibility(
//            visible: authState.state == ViewState.Busy,
//            child: CircularProgressIndicator(
//              valueColor:
//                  AlwaysStoppedAnimation<Color>(ThemeColors.primaryBlue),
//              strokeWidth: 6.0,
//            ),
//          ),
//        )
      ],
    );
  }

  void showErrorMessageDialog(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login'),
            content: Text(error),
            actions: <Widget>[
              RaisedButton(
                elevation: 5.0,
                color: ThemeColors.primaryBlue,
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              )
            ],
          );
        });
  }
}
