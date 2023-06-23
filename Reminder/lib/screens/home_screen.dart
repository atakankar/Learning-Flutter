import 'package:flutter/material.dart';
import 'package:reminder/models/remind.dart';
import 'package:reminder/screens/add_remind_screen.dart';
import 'package:reminder/services/remind_service.dart';
import 'package:reminder/wigdet_assest/remindList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> reminds, lastState;

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> onStart() async {
    reminds = await RemindService().getRemindList();

    DateTime now = DateTime.now();
    for (var element in reminds) {
      DateTime endDateTime = DateTime.parse(element["finishDate"]);
      if (endDateTime.isBefore(now)) {
        Remind remindObj = Remind(
            title: element["title"],
            description: element["description"],
            startDate: element["startDate"],
            finishDate: element["finishDate"],
            period: element["period"]);
        RemindService().deleteRemind(remindObj, context);
      }
    }

    try {
      lastState = await RemindService().getRemindList();
    } catch (e) {}
    return lastState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddRemindScreen()));
        },
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: onStart(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> reminds = snapshot.data!;
              return listReminds(reminds: reminds);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
