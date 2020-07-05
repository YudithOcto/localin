import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localin/analytics/analytic_service.dart';
import 'package:localin/components/decorated_tab_bar.dart';
import 'package:localin/locator.dart';
import 'package:localin/presentation/news/provider/news_header_provider.dart';
import 'package:localin/presentation/news/widgets/collection/collection_content_list_widget.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class CollectionArticleWidget extends StatefulWidget {
  @override
  _CollectionArticleWidgetState createState() =>
      _CollectionArticleWidgetState();
}

class _CollectionArticleWidgetState extends State<CollectionArticleWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabBarController;

  void initState() {
    locator<AnalyticsService>().setScreenName(name: 'ArticleCollectionsTab');
    _tabBarController = new TabController(vsync: this, length: 2);
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
                text: 'Bookmark',
              ),
              Tab(
                text: 'Liked',
              ),
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
                if (drag != null &&
                    (notification.metrics.axisDirection == AxisDirection.left ||
                        notification.metrics.axisDirection ==
                            AxisDirection.right)) {
                  drag.update(notification.dragDetails);
                }
              }
              if (notification is ScrollEndNotification) {
                drag?.cancel();
              }
              return true;
            },
            child: TabBarView(
              controller: _tabBarController,
              children: <Widget>[
                CollectionContentListWidget(
                  isBookmark: 1,
                ),
                CollectionContentListWidget(
                  isLiked: 1,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
