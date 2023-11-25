import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/user_model.dart';

class SearchUserController extends GetxController {
  final Rx<List<UserModel>> _searchedUsers = Rx<List<UserModel>>([]);

  List<UserModel> get searchedUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(firestore
        .collection('Users')
        .where('username', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> retVal = [];
      for (var elem in query.docs) {
        retVal.add(UserModel.fromSnap(elem));
      }
      return retVal;
    }));
  }
}
