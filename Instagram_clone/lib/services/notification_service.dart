import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/notification_model.dart';
import 'package:uuid/uuid.dart';

class NotificationSevice {
  Future<void> addNotification(
    String sendUid,
    String username,
    String receiveUid,
    String type,
  ) async {
    String notiID = const Uuid().v1();

    NotificationModel noti = NotificationModel(
      notificationId: notiID,
      senderUid: sendUid,
      receiveUid: receiveUid,
      senderUsername: username,
      text: type,
      datePublished: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(receiveUid)
        .collection("Activities")
        .doc(notiID)
        .set(noti.toJson());
  }

  Future<void> requestsNotifications(
    bool isIn,
    String uid,
    String username,
    String followId,
  ) async {
    if (isIn) {
      var collection = FirebaseFirestore.instance
          .collection('Notifications')
          .doc(followId)
          .collection("Requests");
      var snapshot = await collection.where('requestUid', isEqualTo: uid).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } else {
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(followId)
          .collection("Requests")
          .add({
        'requestUid': uid,
        "requestUsername": username,
        "datePublished": DateTime.now(),
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getActivatesSnapshots(uid) {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .doc(uid)
        .collection("Activities")
        .orderBy("datePublished", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRequestsSnapshots(uid) {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .doc(uid)
        .collection("Requests")
        .snapshots();
  }
}
