import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatefulWidget {
  final snap;
  const ActivityCard({
    Key? key,
    this.snap,
  }) : super(key: key);

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: widget.snap.data()['senderUsername'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                    text: ' ${widget.snap.data()['text']}',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 4,
              ),
              child: Text(
                DateFormat.yMMMd().format(
                  widget.snap.data()['datePublished'].toDate(),
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
