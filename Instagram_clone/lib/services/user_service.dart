import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/services/notification_service.dart';
import 'package:instagram/services/storage_service.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? getUser(uid) {
    return FirebaseFirestore.instance.collection("Users").doc(uid).snapshots();
  }

  Future<void> followUser(
      String uid, String username, String followId, bool isPrivate) async {
    if (!isPrivate) {
      try {
        DocumentSnapshot snap =
            await _firestore.collection('Users').doc(uid).get();
        List following = (snap.data()! as dynamic)['following'];

        if (following.contains(followId)) {
          await _firestore.collection('Users').doc(followId).update({
            'followers': FieldValue.arrayRemove([uid])
          });

          await _firestore.collection('Users').doc(uid).update({
            'following': FieldValue.arrayRemove([followId])
          });

          await NotificationSevice()
              .addNotification(uid, username, followId, "unfollowed you");
        } else {
          await _firestore.collection('Users').doc(followId).update({
            'followers': FieldValue.arrayUnion([uid])
          });

          await _firestore.collection('Users').doc(uid).update({
            'following': FieldValue.arrayUnion([followId])
          });
          await NotificationSevice()
              .addNotification(uid, username, followId, "start following you");
        }
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    } else {
      try {
        DocumentSnapshot snap =
            await _firestore.collection('Users').doc(followId).get();
        List requests = (snap.data()! as dynamic)['requests'];

        if (requests.contains(uid)) {
          await _firestore.collection('Users').doc(followId).update({
            'requests': FieldValue.arrayRemove([uid])
          });
        } else {
          await _firestore.collection('Users').doc(followId).update({
            'requests': FieldValue.arrayUnion([uid])
          });
        }
        await NotificationSevice().requestsNotifications(
            requests.contains(uid), uid, username, followId);
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    }
  }

  Future<void> requestFollow(
      bool isAccept, currentUserUid, followerUid, followerName) async {
    if (isAccept) {
      await _firestore.collection('Users').doc(currentUserUid).update({
        'followers': FieldValue.arrayUnion([followerUid])
      });

      await _firestore.collection('Users').doc(followerUid).update({
        'following': FieldValue.arrayUnion([currentUserUid])
      });
    }
    await _firestore.collection('Users').doc(currentUserUid).update({
      'requests': FieldValue.arrayRemove([followerUid])
    });

    await NotificationSevice()
        .requestsNotifications(true, followerUid, followerName, currentUserUid);
  }

  Future<String> updateUser({
    required String uid,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      String photoUrl = await StorageService()
          .uploadImageToStorage('profilePics', file, false);
      await _firestore.collection("Users").doc(uid).update({
        "username": username,
        "bio": bio,
        "photoUrl": photoUrl,
      });

      var comments = await _firestore
          .collection("Comments")
          .where("uid", isEqualTo: uid)
          .get();
      for (var doc in comments.docs) {
        await doc.reference.update({
          "profImage": photoUrl,
          "username": username,
        });
      }

      var posts = await _firestore
          .collection("Posts")
          .where("uid", isEqualTo: uid)
          .get();
      for (var doc in posts.docs) {
        await doc.reference.update({
          "profImage": photoUrl,
          "username": username,
        });
      }
      return "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> updateUserPrivate({
    required String uid,
    required bool isPrivate,
    required requests,
  }) async {
    try {
      await _firestore.collection("Users").doc(uid).update({
        "isPrivate": isPrivate,
      });

      if (!isPrivate) {
        for (var id in requests) {
          await _firestore.collection('Users').doc(uid).update({
            'followers': FieldValue.arrayUnion([id])
          });

          await _firestore.collection('Users').doc(id).update({
            'following': FieldValue.arrayUnion([uid])
          });

          await _firestore.collection('Users').doc(uid).update({
            'requests': FieldValue.arrayRemove([id])
          });

          await NotificationSevice()
              .requestsNotifications(requests.contains(id), id, "", uid);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
