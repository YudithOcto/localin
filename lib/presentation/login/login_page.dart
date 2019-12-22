import 'package:flutter/material.dart';
import 'package:localin/api/social_sign_in.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/logo_login_icon.png',
          ),
          SizedBox(
            height: 5.0,
          ),
          Text('Login with Social Networks'),
          SizedBox(
            height: 25.0,
          ),
          Container(
            height: 50.0,
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () async {
                var signin = await SocialSignIn().signInFacebook();
                Navigator.of(context).pushNamed(MainBottomNavigation.routeName,
                    arguments: {'user': signin});
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: Colors.blueAccent,
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
          Container(
            height: 50.0,
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () async {
                var result = await SocialSignIn().signInWithGoogle();
                if (result.isNotEmpty) {
                  Navigator.of(context)
                      .pushNamed(MainBottomNavigation.routeName);
                }
                //
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: Colors.blueAccent,
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
          )
        ],
      ),
    );
  }
}
