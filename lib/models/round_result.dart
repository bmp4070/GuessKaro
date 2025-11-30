class RoundResult {
  const RoundResult({
    required this.roundNumber,
    required this.correct,
    required this.passed,
    required this.duration,
  });

  final int roundNumber;
  final List<String> correct;
  final List<String> passed;
  final Duration duration;

  int get score => correct.length;
}
