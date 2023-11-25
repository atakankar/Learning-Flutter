import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String postId;
  final DateTime datePublished;
  final String username;
  final String profImage;
  final String uid;
  final String text;
  final likes;

  const CommentModel({
    required this.commentId,
    required this.postId,
    required this.datePublished,
    required this.username,
    required this.profImage,
    required this.uid,
    required this.text,
    required this.likes,
  });

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      commentId: snapshot["commentId"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"].toDate(),
      username: snapshot["username"],
      profImage: snapshot["profImage"],
      uid: snapshot["uid"],
      text: snapshot['text'],
      likes: snapshot['likes'],
    );
  }

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "postId": postId,
        "datePublished": datePublished,
        "username": username,
        "profImage": profImage,
        "uid": uid,
        'text': text,
        'likes': likes
      };
}
