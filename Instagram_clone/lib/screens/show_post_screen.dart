import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widget_assets/post_card.dart';

class ShowPostScreen extends StatefulWidget {
  final snap;
  const ShowPostScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<ShowPostScreen> createState() => _ShowPostScreenState();
}

class _ShowPostScreenState extends State<ShowPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Posts")
              .doc(widget.snap["postId"])
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Text('ERROR');
            }

            return PostCard(snap: snapshot.data);
          },
        ));
  }
}
