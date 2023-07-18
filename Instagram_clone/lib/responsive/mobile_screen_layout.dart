import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/theme/theme.dart';
import 'package:instagram/utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  final UserModel user;
  const MobileScreenLayout({Key? key, required this.user}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _pageNo = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _pageNo = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (value) => onPageChanged(value),
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems(widget.user),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Pallete.mobileBackgroundColor,
        activeColor: Pallete.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Pallete.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            backgroundColor: Pallete.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            backgroundColor: Pallete.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            backgroundColor: Pallete.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Pallete.primaryColor,
          ),
        ],
        onTap: (value) => navigationTapped(value),
        currentIndex: _pageNo,
      ),
    );
  }
}
