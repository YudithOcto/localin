import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    notifications.show(id, title, body, _ongoing, payload: 'x');

NotificationDetails get _ongoing {
  final androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'your other channel id',
    'your channel name',
    'your other channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: false,
  );
  final iosChannelSpecific = IOSNotificationDetails();
  return NotificationDetails(
      androidPlatformChannelSpecifics, iosChannelSpecific);
}
