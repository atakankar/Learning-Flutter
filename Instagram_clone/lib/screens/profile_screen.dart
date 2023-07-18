import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/screens/change_password_screen.dart';
import 'package:instagram/screens/edit_profile_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/show_post_screen.dart';
import 'package:instagram/services/auth_service.dart';
import 'package:instagram/services/user_service.dart';
import 'package:instagram/theme/theme.dart';
import 'package:instagram/widget_assets/widget_assets.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var currentUserData;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isRequested = false;
  bool isLoading = false;
  bool isPrivate = false;
  bool _isPrivate = false;
  String email = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var currentUserSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      currentUserData = currentUserSnap.data()!;

      var userSnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.user.uid)
          .get();

      // get post LENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: widget.user.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      email = userSnap.data()!['email'];
      isPrivate = userSnap.data()!['isPrivate'];
      _isPrivate = isPrivate;
      isRequested =
          userSnap.data()!['requests'].contains(currentUserData["uid"]);
      isFollowing =
          userSnap.data()!['followers'].contains(currentUserData["uid"]);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showPopupMenu(BuildContext context, details) async {
    final offset = details.globalPosition;
    final selectedOption = await showMenu(
      color: Pallete.searchBarColor,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        const PopupMenuItem(
          value: 'Change Password',
          child: Text('Change Password'),
        ),
        const PopupMenuItem(
          value: 'Account Privacy',
          child: Text('Account Privacy'),
        ),
      ],
      elevation: 0.0,
    );

    if (selectedOption != null) {
      _navigateToPage(selectedOption);
    }
  }

  void _navigateToPage(String page) {
    if (page == 'Change Password') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(
            email: email,
          ),
        ),
      );
    } else if (page == 'Account Privacy') {
      _showPrivacyDialog();
    }
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Pallete.searchBarColor,
              title: const Text('Profile Privacy'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                      'When activated, people who do not follow you cannot see your profile.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Private "),
                      Switch(
                        value: _isPrivate,
                        onChanged: (bool value) {
                          setState(() {
                            _isPrivate = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    await UserService().updateUserPrivate(
                      uid: currentUserData["uid"],
                      isPrivate: _isPrivate,
                      requests: currentUserData["requests"],
                    );
                    setState(() {
                      isPrivate = _isPrivate;
                    });
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Pallete.mobileBackgroundColor,
              title: Row(
                children: [
                  if (isPrivate)
                    const Icon(
                      Icons.lock_outline,
                      color: Pallete.whiteColor,
                    ),
                  SizedBox(
                    width: isPrivate ? 10 : 0,
                  ),
                  Text(
                    userData['username'],
                  ),
                ],
              ),
              centerTitle: false,
              actions: [
                if (currentUserData["uid"] == widget.user.uid)
                  GestureDetector(
                    onTapUp: (details) {
                      _showPopupMenu(context, details);
                    },
                    child: const Icon(
                      Icons.settings,
                    ),
                  ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    currentUserData["uid"] == widget.user.uid
                                        ? Row(
                                            children: [
                                              FollowButton(
                                                text: 'Edit Profile',
                                                backgroundColor: Pallete
                                                    .mobileBackgroundColor,
                                                textColor: Pallete.primaryColor,
                                                borderColor: Colors.grey,
                                                function: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfileScreen(
                                                        user: UserModel.fromMap(
                                                            userData),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                  onPressed: () async {
                                                    await AuthService()
                                                        .signOut();
                                                    if (context.mounted) {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginScreen(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  icon:
                                                      const Icon(Icons.logout))
                                            ],
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await UserService()
                                                      .followUser(
                                                          currentUserData[
                                                              "uid"],
                                                          currentUserData[
                                                              "username"],
                                                          userData['uid'],
                                                          false);

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : isRequested
                                                ? FollowButton(
                                                    text: 'UnRequest',
                                                    backgroundColor:
                                                        Colors.blue,
                                                    textColor: Colors.white,
                                                    borderColor: Colors.blue,
                                                    function: () async {
                                                      await UserService()
                                                          .followUser(
                                                              currentUserData[
                                                                  "uid"],
                                                              currentUserData[
                                                                  "username"],
                                                              userData['uid'],
                                                              isPrivate);

                                                      setState(() {
                                                        isRequested = false;
                                                      });
                                                    },
                                                  )
                                                : FollowButton(
                                                    text: 'Follow',
                                                    backgroundColor:
                                                        Colors.blue,
                                                    textColor: Colors.white,
                                                    borderColor: Colors.blue,
                                                    function: () async {
                                                      await UserService()
                                                          .followUser(
                                                              currentUserData[
                                                                  "uid"],
                                                              currentUserData[
                                                                  "username"],
                                                              userData['uid'],
                                                              isPrivate);

                                                      setState(() {
                                                        if (isPrivate) {
                                                          isRequested = true;
                                                        } else {
                                                          isFollowing = true;
                                                          followers++;
                                                        }
                                                      });
                                                    },
                                                  )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                isPrivate &&
                        currentUserData["uid"] != widget.user.uid &&
                        !isFollowing
                    ? Center(
                        child: Column(
                          children: const [
                            CircleAvatar(
                              backgroundColor: Pallete.searchBarColor,
                              radius: 70,
                              child: Icon(
                                Icons.lock_outline,
                                color: Pallete.whiteColor,
                                size: 80,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "This account is private",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "You must follow the user to see the posts",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('Posts')
                            .where('uid', isEqualTo: widget.user.uid)
                            .orderBy("datePublished", descending: true)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ShowPostScreen(
                                        snap: snap,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
