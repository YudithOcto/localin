import 'package:flutter/material.dart';
import 'package:localin/animation/fade_in_animation.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/login/phone_verification_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

import 'input_phone_number.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginpage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
              delay: 0.2,
              fadeDirection: FadeDirection.bottom,
              child: Image.asset(
                'images/logo_login_icon.png',
                fit: BoxFit.scaleDown,
                width: 250.0,
                height: 250.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text('Login with Social Networks'),
            SizedBox(
              height: 25.0,
            ),
            FadeAnimation(
              delay: 0.3,
              fadeDirection: FadeDirection.top,
              child: Container(
                height: 50.0,
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () async {
                    var result = await authState.signInWithFacebook();
                    if (result != null &&
                        authState.errorMessage != null &&
                        authState.errorMessage.isEmpty) {
                      if (result.handphone != null &&
                          result.handphone.isNotEmpty) {
                        Navigator.of(context).pushNamed(
                            PhoneVerificationPage.routeName,
                            arguments: {
                              PhoneVerificationPage.phone: result.handphone,
                              PhoneVerificationPage.isBackButtonActive: false,
                            });
                      } else {
                        Navigator.of(context)
                            .pushNamed(InputPhoneNumber.routeName);
                      }
                    } else {
                      showErrorMessageDialog(context, authState.errorMessage);
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Themes.primaryBlue,
                  child: Container(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 0.0,
                          top: 5.0,
                          bottom: 5.0,
                          child: Image.asset(
                            'images/ic_fb_small.png',
                            width: 25,
                            height: 25,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Text(
                            'Facebook',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: Colors.black54,
                    ),
                  ),
                  Text('OR'),
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            FadeAnimation(
              fadeDirection: FadeDirection.top,
              delay: 0.3,
              child: Container(
                height: 50.0,
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () async {
                    var result = await authState.signInWithGoogle();
                    if (result != null) {
                      if (authState.errorMessage.isNotEmpty) {
                        showErrorMessageDialog(context, authState.errorMessage);
                      } else {
                        if (result.handphone != null &&
                            result.handphone.isNotEmpty) {
                          Navigator.of(context).pushNamed(
                              PhoneVerificationPage.routeName,
                              arguments: {
                                PhoneVerificationPage.phone: result.handphone,
                                PhoneVerificationPage.isBackButtonActive: false,
                              });
                        } else {
                          Navigator.of(context)
                              .pushNamed(InputPhoneNumber.routeName);
                        }
                      }
                    }
                    //
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Themes.primaryBlue,
                  child: Container(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 0.0,
                          top: 5.0,
                          bottom: 5.0,
                          child: Image.asset(
                            'images/ic_google.png',
                            color: Colors.white,
                            width: 25,
                            height: 25,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Text(
                            'Google',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Visibility(
            visible: authState.state == ViewState.Busy,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Themes.primaryBlue),
              strokeWidth: 6.0,
            ),
          ),
        )
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
                color: Themes.primaryBlue,
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              )
            ],
          );
        });
  }
}
