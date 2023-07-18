import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/comment_model.dart';
import 'package:instagram/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Stream CommentString postIds
  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsSnapshots(postId) {
    return FirebaseFirestore.instance
        .collection('Comments')
        .where("postId", isEqualTo: postId)
        .orderBy("datePublished", descending: true)
        .snapshots();
  }

  // Post comment
  Future<String> postComment(String postId, String posterUid, String text,
      String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();

        CommentModel com = CommentModel(
          commentId: commentId,
          postId: postId,
          datePublished: DateTime.now(),
          username: name,
          profImage: profilePic,
          uid: uid,
          text: text,
          likes: [],
        );
        if (uid != posterUid) {
          await NotificationSevice()
              .addNotification(uid, name, posterUid, "Commented on your post");
        }
        _firestore.collection('Posts').doc(postId).update({
          'commentIDs': FieldValue.arrayUnion([commentId])
        });
        _firestore.collection('Comments').doc(commentId).set(com.toJson());
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeComment(String commentId, String uid, String name,
      String commenterUid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('Comments').doc(commentId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        if (uid != commenterUid) {
          await NotificationSevice()
              .addNotification(uid, name, commenterUid, "Liked your comment");
        }
        _firestore.collection('Comments').doc(commentId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
