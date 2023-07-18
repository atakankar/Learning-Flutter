import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String senderUid;
  final String receiveUid;
  final String senderUsername;
  final String text;
  final DateTime datePublished;

  const NotificationModel({
    required this.notificationId,
    required this.senderUid,
    required this.receiveUid,
    required this.senderUsername,
    required this.text,
    required this.datePublished,
  });

  static NotificationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return NotificationModel(
      notificationId: snapshot["notificationId"],
      senderUid: snapshot["senderUid"],
      receiveUid: snapshot["receiveUid"],
      senderUsername: snapshot["senderUsername"],
      text: snapshot["text"],
      datePublished: snapshot["datePublished"],
    );
  }

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "senderUid": senderUid,
        "receiveUid": receiveUid,
        "senderUsername": senderUsername,
        "text": text,
        "datePublished": datePublished,
      };
}
