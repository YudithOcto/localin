import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/article/pages/create_article_page.dart';
import 'package:localin/presentation/hotel/booking_detail_page.dart';
import 'package:localin/presentation/hotel/booking_history_page.dart';
import 'package:localin/presentation/hotel/hotel_detail_page.dart';
import 'package:localin/presentation/hotel/success_booking_page.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/community/pages/community_create_edit_page.dart';
import 'package:localin/presentation/community/pages/community_create_event_page.dart';
import 'package:localin/presentation/community/pages/community_detail_page.dart';
import 'package:localin/presentation/login/input_phone_number.dart';
import 'package:localin/presentation/login/phone_verification_page.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/community/widget/community_category_search.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/presentation/profile/other_profile_page.dart';
import 'package:localin/presentation/splash_screen.dart';
import 'package:localin/presentation/notification/notification_list_page.dart';
import 'package:localin/presentation/profile/widgets/connect_dana_account_page.dart';
import 'package:localin/presentation/profile/edit_profile_page.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/provider/profile/user_profile_detail_provider.dart';
import 'package:localin/services/location_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/firebase/message.dart';
import 'model/service/user_location.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

main() {
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    registerNotification();
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
        StreamProvider<UserLocation>(
          create: (context) => LocationServices().locationStream,
        ),
        ChangeNotifierProvider<SearchHotelProvider>(
          create: (_) => SearchHotelProvider(),
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (_) => UserProfileProvider(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigator,
        title: 'Localin App',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            canvasColor: Colors.white,
            fontFamily: 'OpenSans',
            textTheme: ThemeData.light().textTheme.copyWith(
                body1:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                body2: TextStyle(color: Colors.black87),
                title: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'))),
        initialRoute: '/',
        routes: {
          '/': (_) => SplashScreen(),
          LoginPage.routeName: (_) => LoginPage(),
          MainBottomNavigation.routeName: (_) => MainBottomNavigation(),
          EditProfilePage.routeName: (_) => EditProfilePage(),
          ConnectDanaAccountPage.routeName: (_) => ConnectDanaAccountPage(),
          ArticleDetailPage.routeName: (_) => ArticleDetailPage(),
          EmptyPage.routeName: (_) => EmptyPage(),
          CommunityDetailPage.routeName: (_) => CommunityDetailPage(),
          CommunityCreateEditPage.routeName: (_) => CommunityCreateEditPage(),
          CommunityCreateEventPage.routeName: (_) => CommunityCreateEventPage(),
          NotificationListPage.routeName: (_) => NotificationListPage(),
          SuccessBookingPage.routeName: (_) => SuccessBookingPage(),
          BookingDetailPage.routeName: (_) => BookingDetailPage(),
          BookingHistoryPage.routeName: (_) => BookingHistoryPage(),
          HotelDetailPage.routeName: (_) => HotelDetailPage(),
          CommunityCategorySearch.routeName: (_) => CommunityCategorySearch(),
          CreateArticlePage.routeName: (_) => CreateArticlePage(),
          GoogleMapFullScreen.routeName: (_) => GoogleMapFullScreen(),
          WebViewPage.routeName: (_) => WebViewPage(),
          InputPhoneNumber.routeName: (_) => InputPhoneNumber(),
          PhoneVerificationPage.routeName: (_) => PhoneVerificationPage(),
          OtherProfilePage.routeName: (_) => OtherProfilePage(),
        },
      ),
    );
  }

  void registerNotification() {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print(message);
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

  void getToken() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token) {
      sf.setString('tokenFirebase', token);
    });
  }
}
