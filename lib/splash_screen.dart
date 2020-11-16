import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/login/input_phone_number_page.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/presentation/onboarding/onboarding_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  bool updateAndroidIntent = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (updateAndroidIntent) {
        checkGps('');
        updateAndroidIntent = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero).then((value) async {
      final userCache =
          await Provider.of<AuthProvider>(context).getUserFromCache();
      final save = await SharedPreferences.getInstance();
      bool isUserAlreadyDoneVerifying = save.getBool(kUserVerify);
      bool isNeedDisplayCarousel = save.getBool(kUserCarousel);
      if (isNeedDisplayCarousel == null || isNeedDisplayCarousel) {
        Navigator.of(context).pushNamed(OnBoardingPage.routeName);
      } else if (userCache != null) {
        if (userCache.handphone != null &&
            userCache.handphone.isNotEmpty &&
            isUserAlreadyDoneVerifying) {
          checkGps(userCache.id);
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

  checkGps(String userId) async {
    await AnalyticsService().setUserProperties(userId: userId);
    final isGpsOn = await Provider.of<LocationProvider>(context, listen: false)
        .getUserLocation();
    if (isGpsOn) {
      Navigator.of(context)
          .pushReplacementNamed(MainBottomNavigation.routeName);
    } else if (!isGpsOn) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Location'),
              content: Text('You need to enable your gps'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    final AndroidIntent intent = new AndroidIntent(
                      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                    );
                    intent.launch();
                    updateAndroidIntent = true;
                  },
                  color: ThemeColors.primaryBlue,
                  child: Text('Enabled'),
                )
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
