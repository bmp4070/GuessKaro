import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

class WordRepository {
  WordRepository();

  final Map<String, String> _categoryAssets = {
    'Animals': 'assets/words/animals.json',
    'Cartoons & Movies': 'assets/words/cartoons.json',
    'Sports & Actions': 'assets/words/sports.json',
    'Occupations': 'assets/words/occupations.json',
    'Everyday Objects': 'assets/words/objects.json',
  };

  List<String> get availableCategories => _categoryAssets.keys.toList(growable: false);

  Future<List<String>> fetchWords(List<String> categories) async {
    final selected = categories.isEmpty ? availableCategories : categories;
    final words = <String>[];
    for (final category in selected) {
      final assetPath = _categoryAssets[category];
      if (assetPath == null) continue;
      final content = await rootBundle.loadString(assetPath);
      final data = jsonDecode(content) as List<dynamic>;
      words.addAll(data.cast<String>());
    }
    words.shuffle(Random());
    return words;
  }
}
