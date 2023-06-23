import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reminder/models/remind.dart';
import 'package:reminder/screens/home_screen.dart';
import 'package:reminder/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindService {
  Future<void> addRemind(Remind _remind, BuildContext context) async {
    _dialogBuilder(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> remindList = prefs.getStringList('remindList') ?? [];
    List<String> remindListTitle = prefs.getStringList('remindListTitle') ?? [];

    String recipeJson = jsonEncode(_remind.toMap());

    remindList.add(recipeJson);
    remindListTitle.add(_remind.title);

    NotificationService().scheduleFutureNotification(_remind);

    await prefs.setStringList('remindList', remindList);
    await prefs.setStringList('remindListTitle', remindListTitle);

    GoBackHome(context);
  }

  Future<void> deleteRemind(Remind _remind, BuildContext context) async {
    _dialogBuilder(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> remindList = prefs.getStringList('remindList') ?? [];
    List<String> remindListTitle = prefs.getStringList('remindListTitle') ?? [];

    String recipeJson = jsonEncode(_remind.toMap());

    NotificationService().cancelScheduleNotifications(_remind);

    remindList.remove(recipeJson);
    remindListTitle.remove(_remind.title);

    await prefs.setStringList('remindList', remindList);
    await prefs.setStringList('remindListTitle', remindListTitle);
    GoBackHome(context);
  }

  Future<bool> isInRemindList(String isInRemindList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> remindListTitle =
        await prefs.getStringList('remindListTitle') ?? [];
    return await remindListTitle.contains(isInRemindList);
  }

  Future<List> getRemindList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> remindList = prefs.getStringList('remindList') ?? [];
    List _remindList = [];

    for (var element in remindList) {
      Map<String, dynamic> map = json.decode(element);
      _remindList.add(map);
    }
    _remindList.sort((a, b) => a["title"].compareTo(b["title"]));
    return _remindList;
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PLEASE WAIT'),
          content: const CircularProgressIndicator(),
        );
      },
    );
  }

  void GoBackHome(context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }
}
