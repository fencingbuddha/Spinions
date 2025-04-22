import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'coin_flip_screen.dart';
import '../widgets/result_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _choices = [];

  final TextEditingController _choiceController = TextEditingController();

  final List<String> _personalityModes = ['Sarcastic', 'Motivational', 'Chill'];

  String _selectedPersonality = 'Sarcastic';

  final Stream<FortuneItem> _selected =
      Stream.value(FortuneItem(child: Text('')));

  int _currentSelectedIndex = 0;

  void _addChoice() {
    final text = _choiceController.text.trim();

    if (text.isNotEmpty) {
      setState(() {
        _choices.add(text);

        _choiceController.clear();
      });
    }
  }

  String _getPersonalityResponse(String choice) {
    final sarcastic = [
      "Wow... $choice again? Original.",
      "$choice. Bold move. Let's see if it pays off.",
      "$choice? You sure? Fine, I guess."
    ];

    final motivational = [
      "$choice is your destiny!",
      "You're built for $choice!",
      "Rise and choose $choice today!"
    ];

    final chill = [
      "Sure man... $choice works.",
      "$choice feels nice and easy.",
      "Let the vibes guide you to $choice."
    ];

    final rand = Random();

    switch (_selectedPersonality) {
      case 'Motivational':
        return motivational[rand.nextInt(motivational.length)];

      case 'Chill':
        return chill[rand.nextInt(chill.length)];

      default:
        return sarcastic[rand.nextInt(sarcastic.length)];
    }
  }

  void _spinWheel() {
    if (_choices.isEmpty) return;

    setState(() {
      _currentSelectedIndex = Random().nextInt(_choices.length);
    });

    Future.delayed(const Duration(seconds: 2), () {
      final result = _choices[_currentSelectedIndex];

      final quote = _getPersonalityResponse(result);

      showDialog(
        context: context,
        builder: (_) => ResultDialog(
          title: "Result",
          result: quote,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('<¯ Spinions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _choiceController,
                    decoration: const InputDecoration(
                      labelText: 'Add a choice',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addChoice(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addChoice,
                  child: const Text('Add'),
                )
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedPersonality,
              items: _personalityModes.map((mode) {
                return DropdownMenuItem<String>(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPersonality = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_choices.isNotEmpty)
              Expanded(
                child: FortuneWheel(
                  selected: Stream.value(_currentSelectedIndex),
                  items: [
                    for (var choice in _choices)
                      FortuneItem(child: Text(choice)),
                  ],
                  onAnimationEnd: _spinWheel,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _choices.length >= 2 ? _spinWheel : null,
              icon: const Icon(Icons.casino),
              label: const Text("Spin"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CoinFlipScreen(personality: _selectedPersonality),
                  ),
                );
              },
              icon: const Icon(Icons.flip),
              label: const Text("Try Coin Flip"),
            ),
          ],
        ),
      ),
    );
  }
}
