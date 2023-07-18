import 'package:flutter/widgets.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authMethods = AuthService();

  UserModel get getUser => _user!;

  Future<UserModel>? refreshUser() async {
    print("Working!");
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
    return user;
  }
}
