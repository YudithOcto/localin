import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localin/presentation/profile/user_profile/provider/user_profile_detail_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/routes.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics/analytic_service.dart';
import 'locator.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _initLocalNotification();
    registerNotification();
    setupLocator();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider<BookingHistoryProvider>(
          create: (_) => BookingHistoryProvider(),
        ),
        ChangeNotifierProvider<SearchHotelProvider>(
          create: (_) => SearchHotelProvider(
              analyticsService: locator<AnalyticsService>()),
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (_) => UserProfileProvider(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
          navigatorKey: navigator,
          title: 'Localin App',
          theme: ThemeData(
              canvasColor: ThemeColors.black0,
              fontFamily: 'SfProText',
              textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: ThemeText.sfSemiBoldTitle3,
                  bodyText2: ThemeText.sfMediumTitle3,
                  headline6: ThemeText.rodinaTitle3)),
          initialRoute: 'SplashScreenPage',
          navigatorObservers: [
            locator<AnalyticsService>().getAnalyticsObserver(),
          ],
          routes: generalRoutes,
        ),
      ),
    );
  }

  void registerNotification() {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(message);
      showNotification(message);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print(message);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print(message);
      return;
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    getToken();
  }

  showNotification(Map<String, dynamic> data) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'drominder',
      'drominder notification',
      'Channel for drominder',
      playSound: true,
      enableLights: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    try {
      await FlutterLocalNotificationsPlugin().show(
          0,
          '${data['notification']['title']}',
          '${data['notification']['body']}',
          platformChannelSpecifics,
          payload: data.toString());
    } catch (error) {
      print(error);
    }
  }

  _initLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings('home_logo');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      try {
        print(payload);
      } catch (error) {
        print(error);
      }
    });
  }

  void getToken() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token) {
      sf.setString('tokenFirebase', token);
      print('Firebase $token');
    });
  }
}
