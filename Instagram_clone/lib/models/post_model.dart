import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String username;
  final likes;
  final commentIDs;
  final List<String> hashtags;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const PostModel({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.commentIDs,
    required this.hashtags,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        commentIDs: snapshot["commentIDs"],
        hashtags: snapshot["hashtags"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "commentIDs": commentIDs,
        "hashtags": hashtags,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage
      };
}
