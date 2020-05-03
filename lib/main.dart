import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/article/pages/create_article_page.dart';
import 'package:localin/presentation/community/pages/community_feed_page.dart';
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
import 'package:localin/presentation/news/news_detail_page.dart';
import 'package:localin/presentation/news/news_main_page.dart';
import 'package:localin/presentation/onboarding/onboarding_page.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/presentation/profile/user_profile/revamp_edit_profile_page.dart';
import 'package:localin/presentation/profile/user_profile/revamp_profile_page.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_success_page.dart';
import 'package:localin/presentation/search/search_article_page.dart';
import 'package:localin/presentation/search/tag_page/tags_detail_list_page.dart';
import 'package:localin/splash_screen.dart';
import 'package:localin/presentation/inbox/notification_list_page.dart';
import 'package:localin/presentation/webview/article_webview.dart';
import 'package:localin/presentation/webview/revamp_webview.dart';
import 'package:localin/presentation/webview/webview_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:localin/provider/hotel/booking_history_provider.dart';
import 'package:localin/provider/hotel/search_hotel_provider.dart';
import 'package:localin/provider/location/location_provider.dart';
import 'package:localin/themes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/firebase/message.dart';

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
        ChangeNotifierProvider<SearchHotelProvider>(
          create: (_) => SearchHotelProvider(),
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
                  body1: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  body2: TextStyle(color: Colors.black87),
                  title: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'))),
          initialRoute: '/',
          routes: {
            '/': (_) => SplashScreen(),
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
            CommunityFeedPage.routeName: (_) => CommunityFeedPage(),
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
          },
        ),
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
