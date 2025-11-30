class GameConfig {
  const GameConfig({
    required this.roundDuration,
    required this.roundCount,
    required this.selectedCategories,
  });

  final Duration roundDuration;
  final int roundCount;
  final Set<String> selectedCategories;

  GameConfig copyWith({
    Duration? roundDuration,
    int? roundCount,
    Set<String>? selectedCategories,
  }) {
    return GameConfig(
      roundDuration: roundDuration ?? this.roundDuration,
      roundCount: roundCount ?? this.roundCount,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}
