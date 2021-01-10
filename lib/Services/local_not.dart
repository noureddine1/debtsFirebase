import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifie {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future showNotfication() async {
    var androidDetails = AndroidNotificationDetails(
      'channel Id',
      'Local Notfication',
      'the channel description',
      importance: Importance.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Title', 'body', notificationDetails);
  }
}
