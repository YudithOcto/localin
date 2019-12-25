import 'package:flutter/material.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value) async {
      var userCache =
          await Provider.of<AuthProvider>(context).getUserFromCache();
      if (userCache != null) {
        Navigator.of(context).pushNamed(MainBottomNavigation.routeName);
      } else {
        Navigator.of(context).pushNamed(LoginPage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/logo_login_icon.png',
          fit: BoxFit.scaleDown,
          width: 250.0,
          height: 250.0,
        ),
      ),
    );
  }
}
