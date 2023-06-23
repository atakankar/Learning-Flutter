import 'package:flutter/material.dart';
import 'package:reminder/services/notification_service.dart';
import 'package:reminder/src/app.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  tz.initializeTimeZones();
  runApp(App());
}
