import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('Videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String username = userData['username'];
    String photoUrl = userData['photoUrl'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    following = userData['following'].length;
    followers = userData['followers'].length;

    List followersList = (userDoc.data()! as dynamic)['followers'];
    if (followersList.contains(authController.user.uid)) {
      isFollowing = true;
    } else {
      isFollowing = false;
    }

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'photoUrl': photoUrl.toString(),
      'username': username.toString(),
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc =
        await firestore.collection('Users').doc(authController.user.uid).get();

    List following = (doc.data()! as dynamic)['following'];

    if (following.contains(_uid.value)) {
      await firestore.collection('Users').doc(_uid.value).update({
        'followers': FieldValue.arrayRemove([authController.user.uid])
      });

      await firestore.collection('Users').doc(authController.user.uid).update({
        'following': FieldValue.arrayRemove([_uid.value])
      });

      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    } else {
      await firestore.collection('Users').doc(_uid.value).update({
        'followers': FieldValue.arrayUnion([authController.user.uid])
      });

      await firestore.collection('Users').doc(authController.user.uid).update({
        'following': FieldValue.arrayUnion([_uid.value])
      });

      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
