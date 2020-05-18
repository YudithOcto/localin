import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/article/pages/create_article_page.dart';
import 'package:localin/presentation/community/pages/community_discover_page.dart';
import 'package:localin/presentation/gallery/multi_picker_gallery_page.dart';
import 'package:localin/presentation/hotel/booking_detail_page.dart';
import 'package:localin/presentation/hotel/booking_history_page.dart';
import 'package:localin/presentation/hotel/hotel_detail_page.dart';
import 'package:localin/presentation/hotel/success_booking_page.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/community/pages/community_create_edit_page.dart';
import 'package:localin/presentation/community/pages/community_create_event_page.dart';
import 'package:localin/presentation/community/pages/community_detail_page.dart';
import 'package:localin/presentation/login/input_phone_number_page.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/community/widget/community_category_search.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/presentation/news/pages/news_comment_page.dart';
import 'package:localin/presentation/news/pages/news_create_article_page.dart';
import 'package:localin/presentation/news/pages/news_detail_page.dart';
import 'package:localin/presentation/news/pages/news_main_page.dart';
import 'package:localin/presentation/onboarding/onboarding_page.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/presentation/profile/user_profile/provider/user_profile_detail_provider.dart';
import 'package:localin/presentation/profile/user_profile/revamp_edit_profile_page.dart';
import 'package:localin/presentation/profile/user_profile/revamp_profile_page.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_success_page.dart';
import 'package:localin/presentation/search/search_article/search_article_page.dart';
import 'package:localin/presentation/search/search_location/search_location_page.dart';
import 'package:localin/presentation/search/tag_page/tags_detail_list_page.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/splash_screen.dart';
import 'package:localin/presentation/inbox/notification_list_page.dart';
import 'package:localin/presentation/webview/article_webview.dart';
import 'package:localin/presentation/webview/revamp_webview.dart';
import 'package:localin/presentation/webview/webview_page.dart';
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
        )
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
          routes: {
            'SplashScreenPage': (_) => SplashScreen(),
            LoginPage.routeName: (_) => LoginPage(),
            MainBottomNavigation.routeName: (_) => MainBottomNavigation(),
            ArticleDetailPage.routeName: (_) => ArticleDetailPage(),
            EmptyPage.routeName: (_) => EmptyPage(),
            CommunityDetailPage.routeName: (_) => CommunityDetailPage(),
            CommunityCreateEditPage.routeName: (_) => CommunityCreateEditPage(),
            CommunityCreateEventPage.routeName: (_) =>
                CommunityCreateEventPage(),
            NotificationListPage.routeName: (_) => NotificationListPage(),
            SuccessBookingPage.routeName: (_) => SuccessBookingPage(),
            BookingDetailPage.routeName: (_) => BookingDetailPage(),
            BookingHistoryPage.routeName: (_) => BookingHistoryPage(),
            HotelDetailPage.routeName: (_) => HotelDetailPage(),
            CommunityCategorySearch.routeName: (_) => CommunityCategorySearch(),
            CreateArticlePage.routeName: (_) => CreateArticlePage(),
            GoogleMapFullScreen.routeName: (_) => GoogleMapFullScreen(),
            WebViewPage.routeName: (_) => WebViewPage(),
            InputPhoneNumberPage.routeName: (_) => InputPhoneNumberPage(),
            CommunityDiscoverPage.routeName: (_) => CommunityDiscoverPage(),
            OnBoardingPage.routeName: (_) => OnBoardingPage(),
            RevampProfilePage.routeName: (_) => RevampProfilePage(),
            RevampEditProfilePage.routeName: (_) => RevampEditProfilePage(),
            RevampUserVerificationPage.routeName: (_) =>
                RevampUserVerificationPage(),
            RevampUserVerificationSuccessPage.routeName: (_) =>
                RevampUserVerificationSuccessPage(),
            RevampOthersProfilePage.routeName: (_) => RevampOthersProfilePage(),
            RevampWebview.routeName: (_) => RevampWebview(),
            ArticleWebView.routeName: (_) => ArticleWebView(),
            NewsMainPage.routeName: (_) => NewsMainPage(),
            SearchArticlePage.routeName: (_) => SearchArticlePage(),
            TagsDetailListPage.routeName: (_) => TagsDetailListPage(),
            NewsDetailPage.routeName: (_) => NewsDetailPage(),
            NewsCommentPage.routeName: (_) => NewsCommentPage(),
            NewsCreateArticlePage.routeName: (_) => NewsCreateArticlePage(),
            MultiPickerGalleryPage.routeName: (_) => MultiPickerGalleryPage(),
            SearchLocationPage.routeName: (_) => SearchLocationPage(),
          },
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
