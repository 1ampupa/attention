class UserMetrics {
  
  final int currentASScore;

  UserMetrics({
    int? currentASScore,
  }) :
    currentASScore = currentASScore ?? 250; // Starting score

  Map<String, dynamic> toJson() {
    return {
      'currentASScore': currentASScore,
    };
  }

  factory UserMetrics.fromJson(Map<String, dynamic> json) {
    return UserMetrics(
      currentASScore: json['currentASScore'] as int,
    );
  }

}