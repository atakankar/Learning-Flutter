import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/remind.dart';
import 'package:reminder/services/remind_service.dart';

class listReminds extends StatelessWidget {
  const listReminds({
    Key? key,
    required this.reminds,
  }) : super(key: key);

  final List reminds;

  static const List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reminds.length,
      itemBuilder: (context, index) {
        Color itemColor = colors[index % 7];
        print(reminds[index]['finishDate']);
        var finishDate =
            DateFormat("yyyy-MM-dd HH:mm").parse(reminds[index]['finishDate']);
        var _formatDay = DateFormat.yMd().format(finishDate);
        var _formatHour = DateFormat.Hm().format(finishDate);
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black, width: 5.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10),
                color: itemColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Text(
                      reminds[index]['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                reminds[index]['description'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              "Last Notification",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatDay.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatHour.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              RemindService().deleteRemind(
                                  Remind.fromJson(reminds[index]), context);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
