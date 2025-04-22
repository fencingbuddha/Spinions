import 'package:flutter/material.dart';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class SpinnerWheel extends StatelessWidget {
  final List<String> options;

  final Function(int) onResult;

  const SpinnerWheel(
      {required this.options, required this.onResult, super.key});

  @override
  Widget build(BuildContext context) {
    return FortuneWheel(
      selected: Stream.value(Fortune.randomInt(0, options.length)),
      items: [for (var option in options) FortuneItem(child: Text(option))],
      onAnimationEnd: () {
        onResult(Fortune.randomInt(0, options.length));
      },
    );
  }
}
