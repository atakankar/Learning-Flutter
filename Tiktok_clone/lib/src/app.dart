import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktokclone/constants.dart';
import 'package:tiktokclone/screens/auth/login_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "TikTok Clone",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
