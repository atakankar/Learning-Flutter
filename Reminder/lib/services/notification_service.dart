import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/models/remind.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future<void> scheduleFutureNotification(Remind remind) async {
    final NotificationService notificationService = NotificationService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime currentDateTime = DateTime.parse(remind.startDate);
    DateTime endDateTime = DateTime.parse(remind.finishDate);

    print("Start date $currentDateTime Finish date $endDateTime");

    List<DateTime> scheduleDates = [];
    List<int> scheduleIDs = [];
    while (currentDateTime.isBefore(endDateTime)) {
      int randomID = Random().nextInt(10000);
      print("$currentDateTime    $randomID");
      scheduleDates.add(currentDateTime);
      scheduleIDs.add(randomID);

      notificationService.scheduleNotification(
        id: randomID,
        title: remind.title,
        body: remind.description,
        scheduledNotificationDateTime: currentDateTime,
      );
      currentDateTime = currentDateTime.add(Duration(minutes: remind.period));
    }

    List<String> stringsList = scheduleIDs.map((i) => i.toString()).toList();
    await prefs.setStringList('${remind.title}IDs', stringsList);
  }

  Future scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime scheduledNotificationDateTime}) async {
    return _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelScheduleNotifications(Remind remind) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> remindListIDs =
        prefs.getStringList("${remind.title}IDs") ?? [];
    remindListIDs.forEach((element) async {
      await _flutterLocalNotificationsPlugin.cancel(int.parse(element));
    });

    await prefs.remove("${remind.title}IDs");
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }
}
