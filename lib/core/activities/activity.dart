import 'package:attention/core/activities/activity_result.dart';
import 'package:attention/core/activities/trial.dart';

abstract class Activity {
  
  String get id;
  String get name;
  int get setCount;
  int get trialPerSet;
  Duration? get durationPerTrial;

  void prepare();

  Future<ActivityResult> start();

  ActivityResult evaluate(List<Trial> trials);

}