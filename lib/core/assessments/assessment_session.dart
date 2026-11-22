import 'package:attention/core/activities/activity.dart';
import 'package:attention/core/activities/stroop_test/activity_stroop_test.dart';
import 'package:attention/core/enums/session_status.dart';
import 'package:uuid/uuid.dart';

class AssessmentSession {

  final String id;
  final DateTime startedAt;
  late final DateTime completedAt;
  final SessionStatus status;
  final List<Activity> activities;
  final Activity currentActivity;

  AssessmentSession({
    String? id,
    DateTime? startedAt,
    DateTime? completedAt,
    SessionStatus? status,
    List<Activity>? activities,
    Activity? currentActivity,
  }) :
    id = id ?? Uuid().v4(),
    startedAt = startedAt ?? DateTime.now().toUtc(),
    status = status ?? SessionStatus.running,
    activities = activities ?? [ActivityStroopTest()],
    currentActivity = currentActivity ?? activities!.first;
}