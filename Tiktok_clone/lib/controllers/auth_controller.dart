import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  Rx<Uint8List?>? _pickedImage;

  Uint8List? get profilePhoto => _pickedImage?.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  Future<Uint8List?> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
      _pickedImage = Rx<Uint8List?>(await pickedImage.readAsBytes());
      return await pickedImage.readAsBytes();
    }

    return null;
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(Uint8List image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void registerUser(
      String username, String email, String password, Uint8List? image) async {
    try {
      print(username.isNotEmpty);
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        // save out user to our ath and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (image == null) {
          final ByteData imageData =
              await rootBundle.load('assets/default_profile.png');
          image = Uint8List.view(imageData.buffer);
        }
        String downloadUrl = await _uploadToStorage(image);
        UserModel user = UserModel(
          username: username,
          uid: cred.user!.uid,
          photoUrl: downloadUrl,
          email: email,
          bio: "",
          isPrivate: false,
          followers: [],
          following: [],
          requests: [],
        );
        await firestore
            .collection('Users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Loggin gin',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
