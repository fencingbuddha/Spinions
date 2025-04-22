import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/result_dialog.dart';

class CoinFlipScreen extends StatefulWidget {
  final String personality;

  const CoinFlipScreen({required this.personality, super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> {
  bool _flipped = false;

  String _result = '';

  final Map<String, List<String>> _coinThemes = {
    'Yes/No': ['Yes', 'No'],
    'Cat/Dog': ['Cat', 'Dog'],
    'Chaos/Order': ['Chaos', 'Order'],
  };

  String _selectedTheme = 'Yes/No';

  String _getPersonalityQuote(String result) {
    final sarcastic = [
      "Oh joy, it's $result.",
      "$result? Great. Just great.",
      "Wow. So much suspense for $result."
    ];

    final motivational = [
      "$result is the way forward!",
      "Trust in the flip. $result it is!",
      "Believe in $result. Embrace it!"
    ];

    final chill = [
      "$result. Nice and easy.",
      "Vibes say $result.",
      "Whatever works... $result's fine."
    ];

    final rand = Random();

    switch (widget.personality) {
      case 'Motivational':
        return motivational[rand.nextInt(motivational.length)];

      case 'Chill':
        return chill[rand.nextInt(chill.length)];

      default:
        return sarcastic[rand.nextInt(sarcastic.length)];
    }
  }

  void _flipCoin() {
    setState(() {
      _flipped = true;

      final options = _coinThemes[_selectedTheme]!;

      _result = options[Random().nextInt(2)];
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      final quote = _getPersonalityQuote(_result);

      showDialog(
        context: context,
        builder: (_) => ResultDialog(
          title: "Flip Result",
          result: quote,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = _coinThemes[_selectedTheme]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('>™ Coin Flip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedTheme,
              items: _coinThemes.keys.map((theme) {
                return DropdownMenuItem(
                  value: theme,
                  child: Text(theme),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;

                    _flipped = false;

                    _result = '';
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _flipCoin,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 150,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.shade200,
                ),
                child: Text(
                  _flipped ? _result : "Tap to Flip",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Spinner"),
            )
          ],
        ),
      ),
    );
  }
}
