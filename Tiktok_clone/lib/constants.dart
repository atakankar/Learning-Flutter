import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/screens/feed_screen.dart';
import 'package:tiktokclone/screens/profile_screen.dart';
import 'package:tiktokclone/screens/search_screen.dart';
import 'package:tiktokclone/screens/uploadVideo/add_video_screen.dart';

import '../controllers/auth_controller.dart';

List pages = [
  FeedScreen(), //VideoScreen(),
  SearchScreen(), //SearchScreen(),
  const AddVideoScreen(),
  const Center(child: Text('Messages Screen')),
  ProfileScreen(
      uid: authController
          .user.uid), //ProfileScreen(uid: authController.user.uid),
];

const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

var authController = AuthController.instance;
