import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localin/presentation/home/home_page.dart';
import 'package:localin/presentation/inbox/notification_list_page.dart';
import 'package:localin/presentation/news/pages/news_main_page.dart';
import 'package:localin/presentation/profile/user_profile/revamp_profile_page.dart';
import 'package:localin/presentation/transaction/shared_widgets/transaction_list_page.dart';
import 'package:localin/themes.dart';

import '../../text_themes.dart';
import 'floating_action_bottom_app_bar.dart';

class MainBottomNavigation extends StatefulWidget {
  static const routeName = 'BottomNavigationPage';
  static const overrideSelectedMenu = 'SelectedIndex';
  static const overrideSelectedTransactionIndex = 'TransactionSelectionIndex';

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
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      currentSelected = routeArgs != null && routeArgs.isNotEmpty
          ? routeArgs[MainBottomNavigation.overrideSelectedMenu]
          : 0;
      int _transactionIndex = routeArgs != null && routeArgs.isNotEmpty
          ? routeArgs[MainBottomNavigation.overrideSelectedTransactionIndex]
          : 0;
      pages = [
        HomePage(valueChanged: _selectedTab),
        NewsMainPage(),
        TransactionListPage(selectedHeaderIndex: _transactionIndex),
        NotificationListPage(valueChanged: _selectedTab),
        RevampProfilePage()
      ];
      isInit = false;
    }
  }

  void _selectedTab(int index) {
    onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pages[currentSelected],
        bottomNavigationBar: FloatingActionBottomAppBar(
          backgroundColor: ThemeColors.bgNavigation,
          selectedColor: ThemeColors.navigationBlue,
          onTabSelected: _selectedTab,
          selectedTabIndex: currentSelected,
          items: [
            FloatingActionBottomAppBarItem(text: 'Feed'),
            FloatingActionBottomAppBarItem(text: 'News'),
            FloatingActionBottomAppBarItem(text: 'Transaction'),
            FloatingActionBottomAppBarItem(text: 'Inbox'),
            FloatingActionBottomAppBarItem(text: 'Profile'),
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
      return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Confirm exit?',
                        style: ThemeText.sfMediumTitle3,
                      ),
                      SizedBox(height: 8.0),
                      Text('Do you want to exit the app?',
                          style: ThemeText.sfMediumBody
                              .copyWith(color: ThemeColors.black80)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              elevation: 1.0,
                              onPressed: () => Navigator.of(context).pop(false),
                              color: ThemeColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                'No',
                                style: ThemeText.rodinaTitle3
                                    .copyWith(color: ThemeColors.black0),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          Expanded(
                            child: RaisedButton(
                              elevation: 1.0,
                              color: ThemeColors.black0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(
                                    color: ThemeColors.primaryBlue,
                                  )),
                              onPressed: () async {
                                SystemNavigator.pop();
                              },
                              child: Text(
                                'Yes',
                                style: ThemeText.rodinaTitle3
                                    .copyWith(color: ThemeColors.primaryBlue),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }) ??
          false;
    }
    return null;
  }
}
