import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'coin_flip_screen.dart';
import '../widgets/result_dialog.dart';
import 'dart:async';

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

  late StreamController<int> _controller;

  int _currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = StreamController<int>();
  }

  void _addChoice() {
    final rawText = _choiceController.text.trim();

    if (rawText.isEmpty) return;

    // Split by comma and trim each item

    final newItems = rawText
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet();

    setState(() {
      // Only add items not already in the list

      for (final item in newItems) {
        if (!_choices.contains(item)) {
          _choices.add(item);
        }
      }

      _choiceController.clear();
    });
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
    if (_choices.length < 2) return;

    final index = Random().nextInt(_choices.length);

    _controller.add(index); // triggers the spin animation

    Future.delayed(const Duration(seconds: 2), () {
      final result = _choices[index];

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
  void dispose() {
    _controller.close();

    super.dispose();
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
                      labelText: 'Add a choice (or comma-seperated list)',
                      hintText: 'e.g. Tacos, Pizza, Sushi',
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
            const SizedBox(height: 24),
            if (_choices.length >= 2)
              Expanded(
                child: FortuneWheel(
                  selected: _controller.stream,
                  items: _choices
                      .map((choice) => FortuneItem(child: Text(choice)))
                      .toList(),
                  onAnimationEnd: () {},
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text("Add at least 2 choices to spin the wheel."),
              ),
            const SizedBox(height: 24),
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
