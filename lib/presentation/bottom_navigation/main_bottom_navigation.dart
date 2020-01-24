import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/presentation/hotel/booking_history_page.dart';
import 'package:localin/presentation/community/pages/community_feed_page.dart';
import 'package:localin/presentation/home/home_page.dart';
import 'package:localin/presentation/notification/notification_list_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'floating_action_bottom_app_bar.dart';

class MainBottomNavigation extends StatefulWidget {
  static const routeName = '/mainBottomNavigation';
  @override
  _MainBottomNavigationState createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int currentSelected = 0;
  List<Widget> pages = [];
  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      pages = [
        HomePage(
          valueChanged: _selectedTab,
        ),
        CommunityFeedPage(),
        BookingHistoryPage(),
        NotificationListPage(),
        ProfilePage()
      ];
      isInit = false;
    }
  }

  void _selectedTab(int index) {
    if (Provider.of<HomeProvider>(context).isRoomPage) {
      Provider.of<HomeProvider>(context).setRoomPage(false);
    }
    onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pages[currentSelected],
        bottomNavigationBar: FloatingActionBottomAppBar(
          color: Colors.black,
          selectedColor: Colors.blue,
          onTabSelected: _selectedTab,
          selectedTabIndex: currentSelected,
          items: [
            FloatingActionBottomAppBarItem(
              iconData: 'images/home_logo.png',
              text: 'Home',
            ),
            FloatingActionBottomAppBarItem(
                iconData: 'images/search_logo.png', text: 'Search'),
            FloatingActionBottomAppBarItem(
                iconData: 'images/article_logo.png', text: 'Booking'),
            FloatingActionBottomAppBarItem(
                iconData: 'images/notification_logo.png', text: 'Notification'),
            FloatingActionBottomAppBarItem(
                iconData: 'images/account_logo.png', text: 'Profile'),
          ],
        ),
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      currentSelected = page;
    });
  }

  Future<bool> _onWillPop() {
    if (currentSelected != 0) {
      _selectedTab(0);
    } else {
      var state = Provider.of<HomeProvider>(context);
      if (state.isRoomPage) {
        state.setRoomPage(false);
        return null;
      } else {
        return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to exit app?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No')),
                  FlatButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text('Yes'),
                  )
                ],
              ),
            ) ??
            false;
      }
    }
    return null;
  }
}
