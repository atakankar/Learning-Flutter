import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktokclone/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/comment_model.dart';

class CommentController extends GetxController {
  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([]);
  List<CommentModel> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      firestore
          .collection('Comments')
          .where("postId", isEqualTo: _postId)
          .orderBy("datePublished", descending: true)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<CommentModel> retValue = [];
          for (var element in query.docs) {
            retValue.add(CommentModel.fromSnap(element));
          }
          return retValue;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('Users')
            .doc(authController.user.uid)
            .get();
        UserModel user = UserModel.fromSnap(userDoc);

        String commentId = const Uuid().v1();

        CommentModel comment = CommentModel(
          postId: _postId,
          username: user.username,
          datePublished: DateTime.now(),
          likes: [],
          uid: authController.user.uid,
          commentId: commentId,
          profImage: user.photoUrl,
          text: commentText.trim(),
        );
        await firestore.collection('Comments').doc(commentId).set(
              comment.toJson(),
            );
        DocumentSnapshot doc =
            await firestore.collection('Videos').doc(_postId).get();
        await firestore.collection('Videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firestore.collection('Comments').doc(id).get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('Comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('Comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
