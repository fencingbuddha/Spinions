import 'dart:convert';

import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

class PersonalityQuotes {
  static Map<String, List<String>> _quotes = {};

  /// Loads the personality quotes from JSON at app startup

  static Future<void> loadQuotes() async {
    final data = await rootBundle.loadString('assets/personality_quotes.json');

    final Map<String, dynamic> jsonResult = json.decode(data);

    _quotes = {
      for (var key in jsonResult.keys)
        key.toLowerCase(): List<String>.from(jsonResult[key])
    };
  }

  /// Returns a random quote with the given choice injected

  static String getRandomQuote(String mode, String choice) {
    final key = mode.toLowerCase();

    if (!_quotes.containsKey(key)) {
      return "Just go with $choice.";
    }

    final options = _quotes[key]!;

    final quote = options[Random().nextInt(options.length)];

    return quote.replaceAll("{{choice}}", choice);
  }
}
