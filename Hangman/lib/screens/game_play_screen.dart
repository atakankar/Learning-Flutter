import 'dart:math';

import 'package:hangman/models/game.dart';
import 'package:hangman/service/word_service.dart';
import 'package:hangman/ui/widget/letter.dart';
import 'package:flutter/material.dart';

import '../ui/colors.dart';
import '../ui/widget/figure_image.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  _GamePlayScreenState createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  late String word;
  late String hint;
  late int wordLength;
  int playerTrues = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWord();
  }

  _getWord() {
    Random random = new Random();
    Words words = Words();

    int randomNumber = random.nextInt(words.words.length);

    word = (words.words[randomNumber]).word.toUpperCase();
    hint = (words.words[randomNumber]).hint.toUpperCase();

    print(words.words[0].word);

    String str = word;
    Map<String, int> map = {};
    for (int i = 0; i < str.length; i++) {
      int count = map[str[i]] ?? 0;
      map[str[i]] = count + 1;
    }
    print(map);

    wordLength = map.length;
  }

  _finishGame(BuildContext context, String status) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(8),
                      //few more styles
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text("Return Home",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black))),
              ),
            ],
            title: Center(child: Text(status)),
          );
        });
  }

  Game _game = new Game();

  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text("Hangman"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.primaryColorDark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Stack(
              children: [
                figureImage(_game.tries >= 0, "assets/hang.png"),
                figureImage(_game.tries >= 1, "assets/head.png"),
                figureImage(_game.tries >= 2, "assets/body.png"),
                figureImage(_game.tries >= 3, "assets/la.png"),
                figureImage(_game.tries >= 4, "assets/ra.png"),
                figureImage(_game.tries >= 5, "assets/ll.png"),
                figureImage(_game.tries >= 6, "assets/rl.png"),
              ],
            ),
          ),
          Divider(
            height: 5,
            thickness: 5,
            indent: 0,
            endIndent: 0,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: word
                .split("")
                .map((e) => letter(e.toUpperCase(),
                    !_game.selectedChar.contains(e.toUpperCase())))
                .toList(),
          ),
          Center(
            child: Text(hint),
          ),
          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: EdgeInsets.all(8.0),
              children: alphabets.map((e) {
                return RawMaterialButton(
                  onPressed: _game.selectedChar.contains(e)
                      ? null
                      : () {
                          setState(() {
                            _game.selectedChar.add(e);
                            if (!word.split('').contains(e.toUpperCase())) {
                              _game.tries++;
                              if (_game.tries == 6) {
                                _finishGame(context, "LOST");
                              }
                            } else {
                              playerTrues++;
                              checkFinish(context);
                            }
                          });
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fillColor: _game.selectedChar.contains(e)
                      ? Colors.black87
                      : Colors.blue,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  void checkFinish(BuildContext context) {
    if (playerTrues == wordLength) {
      print("FINISHED");
      _finishGame(context, "WON");
    }
  }
}
