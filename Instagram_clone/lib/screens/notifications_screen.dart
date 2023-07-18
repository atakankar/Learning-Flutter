import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/services/notification_service.dart';
import 'package:instagram/widget_assets/widget_assets.dart';

class NotificationsScreen extends StatefulWidget {
  final UserModel user;
  const NotificationsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          if (widget.user.isPrivate)
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 15),
              child: Text(
                "Requests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.user.isPrivate)
            Flexible(
              flex: 1,
              child: StreamBuilder(
                stream:
                    NotificationSevice().getRequestsSnapshots(widget.user.uid),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('ERROR');
                  }
                  if (!snapshot.hasData) {
                    return const Text('No Request');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => RequestCard(
                      snap: snapshot.data!.docs[index],
                      currentUserUid: widget.user.uid,
                    ),
                  );
                },
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 15),
            child: Text(
              "Activity",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            flex: 2,
            child: StreamBuilder(
              stream:
                  NotificationSevice().getActivatesSnapshots(widget.user.uid),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Text('ERROR');
                }
                if (!snapshot.hasData) {
                  return const Text('No Activity');
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => ActivityCard(
                    snap: snapshot.data!.docs[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
