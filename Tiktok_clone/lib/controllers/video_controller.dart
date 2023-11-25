import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/models/video_model.dart';

class VideoController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);
  List<VideoModel> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
      firestore
          .collection("Videos")
          //.orderBy("datePublished", descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<VideoModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(
            VideoModel.fromSnap(element),
          );
        }
        return retVal;
      }),
    );
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('Videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('Videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('Videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
