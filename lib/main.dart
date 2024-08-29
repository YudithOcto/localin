import 'package:flutter/material.dart';
import 'package:localin/presentation/profile/user_profile/provider/user_profile_detail_provider.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/routes.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'analytics/analytic_service.dart';
import 'locator.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final bool isDebugMode;

  MyApp({this.isDebugMode = true});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
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
                  bodyLarge: ThemeText.sfSemiBoldTitle3,
                  bodyMedium: ThemeText.sfMediumTitle3,
                  titleLarge: ThemeText.rodinaTitle3)),
          initialRoute: 'SplashScreenPage',
          navigatorObservers: [
          ],
          routes: generalRoutes,
        ),
      ),
    );
  }
}
