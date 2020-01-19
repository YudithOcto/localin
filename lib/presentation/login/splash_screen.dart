import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final Geolocator location = Geolocator()..forceAndroidLocationManager;
  bool updateAndroidIntent = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (updateAndroidIntent) {
        checkGps();
        updateAndroidIntent = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(seconds: 2)).then((value) async {
      var userCache =
          await Provider.of<AuthProvider>(context).getUserFromCache();
      if (userCache != null) {
        checkGps();
      } else {
        Navigator.of(context).pushNamed(LoginPage.routeName);
      }
    });
  }

  checkGps() async {
    final permissionStatus = await location.checkGeolocationPermissionStatus();
    final isGpsOn = await location.isLocationServiceEnabled();

    if (permissionStatus == GeolocationStatus.granted && isGpsOn) {
      Navigator.of(context).pushNamed(MainBottomNavigation.routeName);
    } else if (!isGpsOn) {
      showDialog(
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
                  color: Themes.primaryBlue,
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
