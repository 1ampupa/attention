class ActivityResult {
  final double score;
  final double accuracy;
  final double averageReactionTime;
  final double rtConsistency;

  const ActivityResult({
    required this.score,
    required this.accuracy,
    required this.averageReactionTime,
    required this.rtConsistency,
  });
}
