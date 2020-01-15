import 'package:flutter/material.dart';
import 'package:localin/components/custom_header_below_base_appbar.dart';
import 'package:localin/presentation/profile/profile_page.dart';

import '../../themes.dart';

class NotificationListPage extends StatefulWidget {
  static const routeName = 'notificationListPage';

  const NotificationListPage({Key key}) : super(key: key);

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
      body: Column(
        children: <Widget>[
          CustomHeaderBelowAppBar(
            title: 'Notifikasi',
          ),
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: ListView(
              children: List.generate(5, (index) {
                return SingleCardNotification();
              }),
            ),
          )
        ],
      ),
    );
  }
}

class SingleCardNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
                'Kali jalan Aria Putra Ciputat sudah sepekan banuyak sampah, '
                'Keluarkan bau menyengat',
                style: kValueStyle.copyWith(fontSize: 14.0),
              ),
              SizedBox(height: 5.0),
              Text(
                'Hari ini, 18:29',
                style:
                    kValueStyle.copyWith(color: Colors.black26, fontSize: 12.0),
              ),
              Divider(
                color: Colors.black54,
              ),
            ],
          ),
        )
      ],
    );
  }
}
