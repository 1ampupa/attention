class TrialResponse<T> {
  final T? answer;
  final Duration? reactionTime;
  final bool timedOut;

  const TrialResponse({
    required this.answer,
    required this.reactionTime,
    required this.timedOut,
  });
}
