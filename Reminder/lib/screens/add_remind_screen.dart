import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/remind.dart';
import 'package:reminder/screens/home_screen.dart';
import 'package:reminder/services/remind_service.dart';

class AddRemindScreen extends StatefulWidget {
  const AddRemindScreen({Key? key}) : super(key: key);

  @override
  _AddRemindScreenState createState() => _AddRemindScreenState();
}

class _AddRemindScreenState extends State<AddRemindScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RemindService remindService = RemindService();

  var remindTitleController = TextEditingController();
  var remindDescriptionController = TextEditingController();
  var remindStartTimeController = TextEditingController();
  var remindFinishTimeController = TextEditingController();

  TimeOfDay currentTime = TimeOfDay.now();
  late TimeOfDay _startTime;
  late TimeOfDay _finishTime;

  var _selectedMinuteValue = "1";
  var _selectedHourValue = "0";
  var _periodMin = <DropdownMenuItem<String>>[];
  var _periodHour = <DropdownMenuItem<String>>[];

  bool inList = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadTimes();
  }

  _loadCategories() {
    for (var i = 1; i < 60; i++) {
      setState(() {
        _periodMin.add(DropdownMenuItem(
          child: Text(
            "$i",
          ),
          value: i.toString(),
        ));
      });
    }
    for (var i = 0; i < 12; i++) {
      setState(() {
        _periodHour.add(DropdownMenuItem(
          child: Text(
            "$i",
          ),
          value: i.toString(),
        ));
      });
    }
  }

  _loadTimes() {
    DateTime now2Min = DateTime.now().add(Duration(minutes: 2));
    DateTime now5Min = DateTime.now().add(Duration(minutes: 5));
    String formattedTime = DateFormat.Hm().format(now2Min);
    remindStartTimeController.text = formattedTime;

    _startTime = TimeOfDay(hour: now2Min.hour, minute: now2Min.minute);
    _finishTime = TimeOfDay(hour: now5Min.hour, minute: now5Min.minute);
  }

  _selectedremindTime(BuildContext context, int index) async {
    var _pickedTime = await showTimePicker(
      context: context,
      initialTime: index == 1 ? _startTime : _finishTime,
    );
    if (_pickedTime != null) {
      setState(() {
        final String formattedTime = _pickedTime.format(context);
        index == 1 ? _startTime = _pickedTime : _finishTime = _pickedTime;
        index == 1
            ? remindStartTimeController.text = formattedTime
            : remindFinishTimeController.text = formattedTime;
      });
    }
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Remind"),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      inList = false;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (inList) {
                      return 'You have same remind';
                    }
                    return null;
                  },
                  controller: remindTitleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Write remind Title",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  controller: remindDescriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Write remind Description",
                  ),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final now = DateTime.now();
                    DateTime dateTime = DateTime.now();
                    if (value != null)
                      dateTime = DateFormat('dd/MM/yyyy HH:mm').parseLoose(
                          "${now.day}/${now.month}/${now.year}" +
                              " " +
                              value.toString());
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    } else if (dateTime
                        .toUtc()
                        .isBefore(now.add(Duration(minutes: 1)))) {
                      return 'Reminder must start within today and not past hour';
                    }
                    return null;
                  },
                  controller: remindStartTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Start Time",
                    hintText: "Pick Start Time",
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectedremindTime(context, 1);
                      },
                      child: Icon(Icons.access_alarm),
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  controller: remindFinishTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Finish Time",
                    hintText: "Pick Finish Time",
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectedremindTime(context, 2);
                      },
                      child: Icon(Icons.alarm_off),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: 'HOUR',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedHourValue,
                          hint: Text("Period"),
                          items: _periodHour,
                          onChanged: (value) {
                            setState(() {
                              _selectedHourValue = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'MINUTE',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedMinuteValue,
                          hint: Text("Period Scale"),
                          items: _periodMin,
                          onChanged: (value) {
                            setState(() {
                              _selectedMinuteValue = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool exists = true;
                      try {
                        exists = await remindService
                            .isInRemindList(remindTitleController.text);
                      } catch (e) {}
                      setState(() {
                        inList = exists;
                        _formKey.currentState!.validate();
                      });
                      if (!exists) {
                        DateTime startDateTime = DateTime.now();
                        DateTime endDateTime = DateTime.now();

                        bool isTimeBefore = compareTime(
                            remindFinishTimeController.text,
                            remindStartTimeController.text);
                        DateFormat formatter = DateFormat('HH:mm');
                        DateTime now = DateTime.now();
                        DateTime tomorrow = now.add(Duration(days: 1));
                        if (isTimeBefore) {
                          DateTime _futureDateTime =
                              formatter.parse(remindFinishTimeController.text);
                          DateTime nextDayTime = DateTime(
                              tomorrow.year,
                              tomorrow.month,
                              tomorrow.day,
                              _futureDateTime.hour,
                              _futureDateTime.minute);
                          endDateTime = nextDayTime;

                          DateTime _currentDateTime =
                              formatter.parse(remindStartTimeController.text);
                          startDateTime = DateTime(now.year, now.month, now.day,
                              _currentDateTime.hour, _currentDateTime.minute);
                        } else {
                          DateTime _endDateTime =
                              formatter.parse(remindFinishTimeController.text);
                          endDateTime = DateTime(now.year, now.month, now.day,
                              _endDateTime.hour, _endDateTime.minute);

                          DateTime _currentDateTime =
                              formatter.parse(remindStartTimeController.text);
                          startDateTime = DateTime(now.year, now.month, now.day,
                              _currentDateTime.hour, _currentDateTime.minute);
                        }

                        var remindObject = Remind(
                          title: remindTitleController.text,
                          description: remindDescriptionController.text,
                          startDate: startDateTime.toString(),
                          finishDate: endDateTime.toString(),
                          period: int.parse(_selectedMinuteValue) +
                              (int.parse(_selectedHourValue) * 60),
                        );
                        remindService.addRemind(remindObject, context);
                      }
                    }
                  },
                  color: Colors.blue,
                  child: Text("Save"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool compareTime(String time1, String time2) {
    final DateFormat formatter = DateFormat('HH:mm');
    final DateTime dateTime1 = formatter.parse(time1);
    final DateTime dateTime2 = formatter.parse(time2);

    return dateTime1.isBefore(dateTime2);
  }
}
