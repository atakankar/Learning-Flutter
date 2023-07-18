import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/theme/theme.dart';

class HashtagText extends StatelessWidget {
  final String text;
  final String name;
  const HashtagText({
    super.key,
    required this.text,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];

    textspans.add(
      TextSpan(
        text: '$name ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                //Navigator.push(
                //  context,
                //  HashtagView.route(element),
                //);
              },
          ),
        );
      } else {
        textspans.add(
          TextSpan(
            text: '$element ',
          ),
        );
      }
    });

    return Text.rich(
      TextSpan(
        children: textspans,
      ),
    );
  }
}
