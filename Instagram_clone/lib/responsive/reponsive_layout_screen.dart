import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  late UserModel user;
  @override
  void initState() {
    super.initState();
    //addData();
  }

  Future<bool> fetchData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    user = (await userProvider.refreshUser())!;
    return true;
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('An error: ${snapshot.error}');
          } else {
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > webScreenSize) {
                return WebScreenLayout(user: user);
              }
              return MobileScreenLayout(user: user);
            });
          }
        });
  }
}
