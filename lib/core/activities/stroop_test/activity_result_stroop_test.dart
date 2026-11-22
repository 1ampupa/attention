import 'package:attention/core/activities/activity_result.dart';

class ActivityResultStroopTest extends ActivityResult {

  final int correct;

  ActivityResultStroopTest({
    required this.correct,
    required super.score,
    required super.accuracy,
    required super.averageReactionTime,
    required super.rtConsistency,
  });

}
