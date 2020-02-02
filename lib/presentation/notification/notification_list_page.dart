import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/presentation/article/pages/article_detail_page.dart';
import 'package:localin/presentation/hotel/booking_detail_page.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/provider/notification/notification_provider.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:provider/provider.dart';

import '../../themes.dart';

class NotificationListPage extends StatefulWidget {
  static const routeName = 'notificationListPage';

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Image.asset(
          'images/app_bar_logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 50.0,
        ),
      ),
      body: ChangeNotifierProvider<NotificationProvider>(
        create: (_) => NotificationProvider(),
        child: ColumnContent(),
      ),
    );
  }
}

class ColumnContent extends StatelessWidget {
  final int pageSize = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomHeaderBelowAppBar(
          title: 'Notifikasi',
        ),
        SizedBox(
          height: 15.0,
        ),
        Expanded(
          child: PagewiseListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            pageSize: pageSize,
            itemBuilder: (context, item, index) {
              return SingleCardNotification(
                detailModel: item,
              );
            },
            showRetry: false,
            pageFuture: (pageIndex) {
              return Provider.of<NotificationProvider>(context)
                  .getNotificationList(pageIndex + 1, pageSize);
            },
          ),
        )
      ],
    );
  }
}

class SingleCardNotification extends StatelessWidget {
  final NotificationDetailModel detailModel;
  SingleCardNotification({this.detailModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (detailModel?.type) {
          case 'hotel':
            Navigator.of(context).pushNamed(BookingDetailPage.routeName,
                arguments: {BookingDetailPage.bookingId: detailModel?.typeId});
            break;
          case 'artikel':
            Navigator.of(context)
                .pushNamed(ArticleDetailPage.routeName, arguments: {
              ArticleDetailPage.articleId: detailModel?.typeId,
              ArticleDetailPage.commentPage: false
            });
            break;
          case 'komunitas':
            break;
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 15.0,
          ),
          Icon(
            Icons.people,
            color: Themes.primaryBlue,
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${detailModel?.message}',
                  style: kValueStyle.copyWith(fontSize: 14.0),
                ),
                SizedBox(height: 5.0),
                Text(
                  '${DateHelper.formatDateBookingDetail(detailModel?.createdAt)}',
                  style: kValueStyle.copyWith(
                      color: Colors.black26, fontSize: 12.0),
                ),
                Divider(
                  color: Colors.black54,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
