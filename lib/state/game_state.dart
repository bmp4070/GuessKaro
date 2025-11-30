import 'dart:async';

import 'package:flutter/material.dart';

import '../models/game_config.dart';
import '../models/round_result.dart';
import 'word_repository.dart';

class GameState extends ChangeNotifier {
  GameState({required WordRepository wordRepository})
      : _wordRepository = wordRepository,
        _config = GameConfig(
          roundDuration: const Duration(seconds: 60),
          roundCount: 1,
          selectedCategories: {},
        );

  final WordRepository _wordRepository;
  GameConfig _config;
  Timer? _timer;
  Timer? _countdown;

  int _roundNumber = 1;
  Duration _remaining = const Duration(seconds: 60);
  List<String> _wordQueue = [];
  int _currentIndex = 0;
  List<String> correct = [];
  List<String> passed = [];
  RoundResult? lastResult;

  bool highContrast = false;
  bool largeText = false;
  bool mute = false;
  bool haptics = true;

  List<String> get availableCategories => _wordRepository.availableCategories;
  Set<String> get selectedCategories => _config.selectedCategories;
  int get roundCount => _config.roundCount;
  Duration get roundDuration => _config.roundDuration;
  Duration get remaining => _remaining;
  int get roundNumber => _roundNumber;

  String get currentWord =>
      _wordQueue.isNotEmpty && _currentIndex < _wordQueue.length
          ? _wordQueue[_currentIndex]
          : 'Get ready!';

  bool get hasSelection => selectedCategories.isNotEmpty;
  bool get isRoundActive => _timer?.isActive ?? false;

  void toggleCategory(String category) {
    final updated = {...selectedCategories};
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    _config = _config.copyWith(selectedCategories: updated);
    notifyListeners();
  }

  void setRoundDuration(Duration duration) {
    _config = _config.copyWith(roundDuration: duration);
    _remaining = duration;
    notifyListeners();
  }

  void setRoundCount(int count) {
    _config = _config.copyWith(roundCount: count);
    notifyListeners();
  }

  Future<void> prepareRound() async {
    _wordQueue = await _wordRepository.fetchWords(selectedCategories.toList());
    _wordQueue = _wordQueue.take(50).toList();
    _currentIndex = 0;
    correct = [];
    passed = [];
    _remaining = roundDuration;
    _timer?.cancel();
    _timer = Timer(roundDuration, finishRound);
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining > Duration.zero) {
        _remaining -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        timer.cancel();
        finishRound();
      }
    });
    notifyListeners();
  }

  void markCorrect() {
    if (_wordQueue.isEmpty) return;
    correct.add(currentWord);
    _advance();
  }

  void markPass() {
    if (_wordQueue.isEmpty) return;
    passed.add(currentWord);
    _advance();
  }

  void toggleHighContrast(bool value) {
    highContrast = value;
    notifyListeners();
  }

  void toggleLargeText(bool value) {
    largeText = value;
    notifyListeners();
  }

  void toggleMute(bool value) {
    mute = value;
    notifyListeners();
  }

  void toggleHaptics(bool value) {
    haptics = value;
    notifyListeners();
  }

  void finishRound() {
    _timer?.cancel();
    lastResult = RoundResult(
      roundNumber: _roundNumber,
      correct: List.unmodifiable(correct),
      passed: List.unmodifiable(passed),
      duration: roundDuration,
    );
    _roundNumber = (_roundNumber % roundCount) + 1;
    _countdown?.cancel();
    _remaining = Duration.zero;
    notifyListeners();
  }

  void _advance() {
    if (_currentIndex + 1 < _wordQueue.length) {
      _currentIndex++;
    } else {
      finishRound();
    }
    notifyListeners();
  }
}
