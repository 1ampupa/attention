import 'package:attention/core/assessments/assessment_session.dart';

class AssessmentResult {
  final AssessionSession session;
  final Map rawMetrics;
  final Map calculatedMetrics;

  AssessmentResult({
    required this.session,
    required this.rawMetrics
  }) :
    calculatedMetrics = {};

}