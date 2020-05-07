import 'package:flutter/material.dart';
import 'package:localin/presentation/inbox/widgets/notification_column_content_widget.dart';

import 'package:localin/provider/notification/notification_provider.dart';
import 'package:localin/themes.dart';
import 'package:provider/provider.dart';

class NotificationListPage extends StatefulWidget {
  static const routeName = 'notificationListPage';

  final ValueChanged<int> valueChanged;
  NotificationListPage({this.valueChanged});
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black10,
      body: ChangeNotifierProvider<NotificationProvider>(
        create: (_) => NotificationProvider(),
        child: SafeArea(
            child: NotificationColumnContentWidget(
                valueChanged: widget.valueChanged)),
      ),
    );
  }
}
