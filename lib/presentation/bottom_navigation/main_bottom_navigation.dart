import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/presentation/article/article_page.dart';
import 'package:localin/presentation/community/community_page.dart';
import 'package:localin/presentation/home/home_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/presentation/search/search_page.dart';
import 'floating_action_bottom_app_bar.dart';

class MainBottomNavigation extends StatefulWidget {
  static const routeName = '/mainBottomNavigation';
  @override
  _MainBottomNavigationState createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int currentSelected = 0;

  void _selectedTab(int index) {
    onPageChanged(index);
  }

  void _selectedTabWithAnimation(int index) {
    animatePageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            SearchPage(),
            ArticlePage(),
            CommunityPage(),
            ProfilePage()
          ],
          controller: pageController,
        ),
        extendBody: true,
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
                iconData: 'images/article_logo.png', text: 'My Bookings'),
            FloatingActionBottomAppBarItem(
                iconData: 'images/notification_logo.png', text: 'Notification'),
            FloatingActionBottomAppBarItem(
                iconData: 'images/account_logo.png', text: 'Profile'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      currentSelected = page;
      pageController.jumpToPage(page);
    });
  }

  void animatePageChanged(int page) {
    setState(() {
      currentSelected = page;
      pageController.animateToPage(page,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  PageController pageController =
      PageController(initialPage: 0, keepPage: false);

  Future<bool> _onWillPop() {
    if (currentSelected != 0) {
      _selectedTab(0);
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
    return null;
  }
}
