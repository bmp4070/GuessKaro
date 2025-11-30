import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'state/game_state.dart';
import 'state/word_repository.dart';

void main() {
  final wordRepository = WordRepository();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(wordRepository: wordRepository),
      child: const GuessKaroApp(),
    ),
  );
}
