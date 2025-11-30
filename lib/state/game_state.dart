import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        ) {
    _loadPreferences();
  }

  final WordRepository _wordRepository;
  GameConfig _config;
  SharedPreferences? _prefs;
  Timer? _timer;
  Timer? _countdown;
  bool _isPreparing = false;

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

  static const _prefHighContrast = 'pref_high_contrast';
  static const _prefLargeText = 'pref_large_text';
  static const _prefMute = 'pref_mute';
  static const _prefHaptics = 'pref_haptics';
  static const _prefRoundDuration = 'pref_round_duration';
  static const _prefRoundCount = 'pref_round_count';

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
    _savePreference(_prefRoundDuration, duration.inSeconds);
    notifyListeners();
  }

  void setRoundCount(int count) {
    _config = _config.copyWith(roundCount: count);
    _savePreference(_prefRoundCount, count);
    notifyListeners();
  }

  Future<void> prepareRound() async {
    if (_isPreparing) return;
    _isPreparing = true;
    _cancelTimers();
    try {
      _wordQueue =
          await _wordRepository.fetchWords(selectedCategories.toList());
      _wordQueue = _wordQueue.take(50).toList();
      _currentIndex = 0;
      correct = [];
      passed = [];
      _remaining = roundDuration;
      _timer = Timer(roundDuration, finishRound);
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
    } finally {
      _isPreparing = false;
    }
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
    _savePreference(_prefHighContrast, value);
    notifyListeners();
  }

  void toggleLargeText(bool value) {
    largeText = value;
    _savePreference(_prefLargeText, value);
    notifyListeners();
  }

  void toggleMute(bool value) {
    mute = value;
    _savePreference(_prefMute, value);
    notifyListeners();
  }

  void toggleHaptics(bool value) {
    haptics = value;
    _savePreference(_prefHaptics, value);
    notifyListeners();
  }

  void finishRound() {
    if (_isPreparing) return;
    _cancelTimers();
    lastResult = RoundResult(
      roundNumber: _roundNumber,
      correct: List.unmodifiable(correct),
      passed: List.unmodifiable(passed),
      duration: roundDuration,
    );
    _roundNumber = (_roundNumber % roundCount) + 1;
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

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    highContrast = _prefs?.getBool(_prefHighContrast) ?? highContrast;
    largeText = _prefs?.getBool(_prefLargeText) ?? largeText;
    mute = _prefs?.getBool(_prefMute) ?? mute;
    haptics = _prefs?.getBool(_prefHaptics) ?? haptics;

    final storedDuration = _prefs?.getInt(_prefRoundDuration);
    final storedCount = _prefs?.getInt(_prefRoundCount);

    if (storedDuration != null) {
      _config = _config.copyWith(roundDuration: Duration(seconds: storedDuration));
      _remaining = _config.roundDuration;
    }
    if (storedCount != null) {
      _config = _config.copyWith(roundCount: storedCount);
    }
    notifyListeners();
  }

  Future<void> _savePreference(String key, Object value) async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  void _cancelTimers() {
    _timer?.cancel();
    _countdown?.cancel();
    _timer = null;
    _countdown = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}
