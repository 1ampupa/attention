import 'package:attention/core/enums/session_status.dart';
import 'package:uuid/uuid.dart';

class AssessmentSession {

  final String id;
  final DateTime startedAt;
  late final DateTime completedAt;
  final SessionStatus status;

  AssessmentSession({
    String? id,
    DateTime? startedAt,
    DateTime? completedAt,
    SessionStatus? status,
  }) :
    id = id ?? Uuid().v4(),
    startedAt = startedAt ?? DateTime.now().toUtc(),
    status = SessionStatus.running;

}