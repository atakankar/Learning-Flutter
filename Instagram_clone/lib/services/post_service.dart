import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/models/post_model.dart';
import 'package:instagram/services/notification_service.dart';
import 'package:instagram/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    final hashtags = _getHashtagsFromText(description);
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageService().uploadImageToStorage('Posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      PostModel post = PostModel(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        commentIDs: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        hashtags: hashtags,
      );
      _firestore.collection('Posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, String name,
      String posterUid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        if (uid != posterUid) {
          await NotificationSevice()
              .addNotification(uid, name, posterUid, "Liked your post");
        }
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('Posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Stream Posts
  Stream<QuerySnapshot<Map<String, dynamic>>> getPostSnapshots(followings) {
    List follow = followings;
    return FirebaseFirestore.instance
        .collection('Posts')
        .where('uid', whereIn: follow)
        .orderBy("datePublished", descending: true)
        .snapshots();
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
