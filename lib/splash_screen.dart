import 'package:flutter/material.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/login/input_phone_number_page.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/presentation/onboarding/onboarding_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      final userCache =
          await Provider.of<AuthProvider>(context).getUserFromCache();
      final save = await SharedPreferences.getInstance();
      bool isUserAlreadyDoneVerifying = save.getBool(kUserVerify) ?? false;
      bool isNeedDisplayCarousel = save.getBool(kUserCarousel) ?? false;
      if (isNeedDisplayCarousel == null || isNeedDisplayCarousel) {
        Navigator.of(context).pushNamed(OnBoardingPage.routeName);
      } else if (userCache != null) {
        if (userCache.handphone != null &&
            userCache.handphone.isNotEmpty &&
            isUserAlreadyDoneVerifying) {
          Navigator.of(context)
              .pushReplacementNamed(MainBottomNavigation.routeName);
        } else {
          Navigator.of(context)
              .pushReplacementNamed(InputPhoneNumberPage.routeName, arguments: {
            InputPhoneNumberPage.userPhoneVerificationCode: userCache.handphone
          });
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
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
