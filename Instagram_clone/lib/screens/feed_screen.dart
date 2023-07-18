import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/services/post_service.dart';
import 'package:instagram/services/user_service.dart';
import 'package:instagram/theme/theme.dart';
import 'package:instagram/utils/global_variable.dart';
import 'package:instagram/widget_assets/widget_assets.dart';

class FeedScreen extends StatefulWidget {
  final String uid;

  const FeedScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Pallete.mobileBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          colorFilter: const ColorFilter.mode(
            Pallete.primaryColor,
            BlendMode.srcIn,
          ),
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: UserService().getUser(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          List follow = snapshot.data!["following"];
          return follow.isEmpty
              ? const Center(
                  child: Text(
                    "Let's Find Someone",
                  ),
                )
              : StreamBuilder(
                  stream: PostService().getPostSnapshots(follow),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return const Text('ERROR');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > webScreenSize ? width * 0.3 : 0,
                          vertical: width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
