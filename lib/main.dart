import 'package:flutter/material.dart';
import 'package:localin/presentation/article/article_detail_page.dart';
import 'package:localin/presentation/booking/booking_detail_page.dart';
import 'package:localin/presentation/booking/booking_history_page.dart';
import 'package:localin/presentation/booking/room_detail_page.dart';
import 'package:localin/presentation/booking/success_booking_page.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/community/community_create_edit_page.dart';
import 'package:localin/presentation/community/community_create_event_page.dart';
import 'package:localin/presentation/community/community_profile.dart';
import 'package:localin/presentation/error_page/page_404.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/presentation/login/splash_screen.dart';
import 'package:localin/presentation/notification/notification_list_page.dart';
import 'package:localin/presentation/profile/widgets/connect_dana_account_page.dart';
import 'package:localin/presentation/profile/edit_profile_page.dart';
import 'package:localin/provider/auth_provider.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        )
      ],
      child: MaterialApp(
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
          Page404.routeName: (_) => Page404(),
          CommunityProfile.routeName: (_) => CommunityProfile(),
          CommunityCreateEditPage.routeName: (_) => CommunityCreateEditPage(),
          CommunityCreateEventPage.routeName: (_) => CommunityCreateEventPage(),
          NotificationListPage.routeName: (_) => NotificationListPage(),
          SuccessBookingPage.routeName: (_) => SuccessBookingPage(),
          BookingDetailPage.routeName: (_) => BookingDetailPage(),
          BookingHistoryPage.routeName: (_) => BookingHistoryPage(),
          RoomDetailPage.routeName: (_) => RoomDetailPage(),
        },
      ),
    );
  }
}
