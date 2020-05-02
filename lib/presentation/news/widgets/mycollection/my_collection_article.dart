import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localin/components/decorated_tab_bar.dart';
import 'package:localin/presentation/news/provider/news_header_provider.dart';
import 'package:provider/provider.dart';

import '../../../../text_themes.dart';
import '../../../../themes.dart';

class MyCollectionArticle extends StatefulWidget {
  @override
  _MyCollectionArticleState createState() => _MyCollectionArticleState();
}

class _MyCollectionArticleState extends State<MyCollectionArticle>
    with SingleTickerProviderStateMixin {
  TabController _tabBarController;

  void initState() {
    _tabBarController = new TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Local dragStartDetail.
    DragStartDetails dragStartDetails;
    // Current drag instance - should be instantiated on overscroll and updated alongside.
    Drag drag;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        DecoratedTabBar(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ThemeColors.black60,
              ),
            ),
          ),
          tabBar: TabBar(
            controller: _tabBarController,
            indicatorWeight: 3.0,
            labelStyle: ThemeText.sfSemiBoldBody,
            labelColor: ThemeColors.primaryBlue,
            unselectedLabelColor: ThemeColors.black60,
            tabs: <Widget>[
              Tab(
                text: 'Publish',
              ),
              Tab(
                text: 'Draft',
              ),
              Tab(
                text: 'Trash',
              )
            ],
          ),
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                dragStartDetails = notification.dragDetails;
              }
              if (notification is OverscrollNotification) {
                drag = Provider.of<NewsHeaderProvider>(context, listen: false)
                    .pageController
                    .position
                    .drag(dragStartDetails, () {});
                drag.update(notification.dragDetails);
              }
              if (notification is ScrollEndNotification) {
                drag?.cancel();
              }
              return true;
            },
            child: TabBarView(
              controller: _tabBarController,
              children: <Widget>[
                Text('publish'),
                Text('draft'),
                Text('trash'),
              ],
            ),
          ),
        )
      ],
    );
  }
}
