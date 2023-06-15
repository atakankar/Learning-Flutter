import 'package:hangman/ui/colors.dart';
import 'package:flutter/material.dart';

Widget letter(String character, bool hidden) {
  return Container(
    height: 65,
    width: 50,
    padding: EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: AppColor.primaryColorDark,
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Visibility(
      visible: !hidden,
      child: Text(
        character,
        style: TextStyle(
            color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
