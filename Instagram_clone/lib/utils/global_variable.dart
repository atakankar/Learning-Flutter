import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/notifications_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems(UserModel user) {
  return [
    FeedScreen(uid: user.uid),
    const SearchScreen(),
    const AddPostScreen(),
    NotificationsScreen(user: user),
    ProfileScreen(user: user),
  ];
}
