import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final bool isPrivate;
  final List followers;
  final List following;
  final List requests;

  const UserModel({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.isPrivate,
    required this.followers,
    required this.following,
    required this.requests,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      isPrivate: snapshot["isPrivate"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      requests: snapshot["requests"],
    );
  }

  static UserModel fromMap(Map<dynamic, dynamic> snap) {
    var snapshot = snap;

    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      isPrivate: snapshot["isPrivate"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      requests: snapshot["requests"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "isPrivate": isPrivate,
        "followers": followers,
        "following": following,
        "requests": requests,
      };
}
