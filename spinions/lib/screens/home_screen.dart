import 'dart:math';

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../widgets/result_dialog.dart';

import '../widgets/personality_selector.dart';

import '../utils/personality_quotes.dart';

import 'coin_flip_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _choices = [];

  final TextEditingController _choiceController = TextEditingController();

  final List<String> _personalityModes = [
    'Sarcastic',
    'Motivational',
    'Chill',
    'Wise',
    'Silly',
    'Gothic',
    'Chaotic',
  ];

  String _selectedPersonality = 'Sarcastic';

  late StreamController<int> _controller;

  int _currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = StreamController<int>();
  }

  @override
  void dispose() {
    _controller.close();

    super.dispose();
  }

  void _addChoice() {
    final rawText = _choiceController.text.trim();

    if (rawText.isEmpty) return;

    final newItems = rawText
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet();

    setState(() {
      for (final item in newItems) {
        if (!_choices.contains(item)) {
          _choices.add(item);
        }
      }

      _choiceController.clear();
    });
  }

  void _spinWheel() {
    if (_choices.length < 2) return;

    final index = Random().nextInt(_choices.length);

    _controller.add(index);

    Future.delayed(const Duration(seconds: 2), () {
      final result = _choices[index];

      final quote =
          PersonalityQuotes.getRandomQuote(_selectedPersonality, result);

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
                      labelText: 'Add a choice (or comma-separated list)',
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
            PersonalitySelector(
              selected: _selectedPersonality,
              options: _personalityModes,
              onChanged: (value) {
                setState(() {
                  _selectedPersonality = value;
                });
              },
            ),
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
