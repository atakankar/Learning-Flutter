import 'package:flutter/material.dart';
import 'package:instagram/services/user_service.dart';
import 'package:instagram/theme/pallete.dart';
import 'package:instagram/widget_assets/follow_button.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatefulWidget {
  final snap;
  final String currentUserUid;
  const RequestCard({
    Key? key,
    this.snap,
    required this.currentUserUid,
  }) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: DateFormat.yMMMd().format(
                      widget.snap.data()['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const TextSpan(
                    text: '    ',
                  ),
                  TextSpan(
                      text: widget.snap.data()['requestUsername'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  const TextSpan(
                    text: ' wants to follow you',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FollowButton(
                  text: 'Reject',
                  backgroundColor: Pallete.mobileBackgroundColor,
                  textColor: Pallete.primaryColor,
                  borderColor: Colors.grey,
                  function: () async {
                    await UserService().requestFollow(
                      false,
                      widget.currentUserUid,
                      widget.snap.data()['requestUid'],
                      widget.snap.data()['requestUsername'],
                    );
                    setState(() {});
                  },
                  width: 150,
                ),
                FollowButton(
                  text: 'Accept',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  borderColor: Colors.blue,
                  function: () async {
                    await UserService().requestFollow(
                      true,
                      widget.currentUserUid,
                      widget.snap.data()['requestUid'],
                      widget.snap.data()['requestUsername'],
                    );
                    setState(() {});
                  },
                  width: 150,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
