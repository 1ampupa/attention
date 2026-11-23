import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:attention/core/activities/activity.dart';
import 'package:attention/core/activities/activity_result.dart';
import 'package:attention/core/activities/trial.dart';
import 'package:attention/core/activities/trial_response.dart';

import 'package:attention/core/activities/stroop_test/trial_stroop_test.dart';
import 'package:attention/core/activities/stroop_test/activity_result_stroop_test.dart';

enum ActivityStateStroopTest { prepare, countdown, ingame }

class ActivityStroopTest extends Activity {
  @override
  String get id => "stroop_test";

  @override
  String get name => "Stroop Test";

  @override
  int get setCount => 3;

  @override
  int get trialPerSet => 20;

  @override
  Duration? get durationPerTrial => null;

  @override
  ActivityResultStroopTest? get result => evaluate(trials);

  // Stroop Test Variables

  final Random random;

  static const List<Color> _allowedColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  static final Map<Color, String> _colorsName = {
    Colors.red: "RED",
    Colors.orange: "ORANGE",
    Colors.yellow: "YELLOW",
    Colors.green: "GREEN",
    Colors.blue: "BLUE",
    Colors.purple: "PURPLE",
  };

  static final colorCount = 4;

  int currentSet = 0;
  int currentTrial = 0;
  int currentTrialIndex = 0;

  ActivityStateStroopTest state = ActivityStateStroopTest.prepare;
  bool _completed = false;

  List<List<Color>> colorSets = [];
  List<TrialStroopTest> trials = [];

  Completer<TrialResponse<Color>>? _inputCompleter;

  ActivityStroopTest({Random? random, ActivityStroopTest? result})
    : random = random ?? Random();

  // Gameplay

  @override
  void prepare() {
    trials.clear();
    colorSets.clear();
    for (int i = 0; i < setCount; i++) {
      colorSets.add(_generateColorsSet(colorCount));
    }
    _generateTrials();
  }

  void _generateTrials() {
    for (int i = 0; i < setCount; i++) {
      for (int j = 0; j < trialPerSet; j++) {
        trials.add(
          TrialStroopTest(
            wordColor: colorSets[i][random.nextInt(colorSets[i].length)],
            displayColor: colorSets[i][random.nextInt(colorSets[i].length)],
          ),
        );
      }
    }
  }

  List<Color> _generateColorsSet(int amount) {
    final List<Color> shuffled = List.from(_allowedColors)..shuffle(random);
    return shuffled.take(amount).toList();
  }

  @override
  Future<ActivityResult> start() async {
    currentSet = 0;
    currentTrial = 0;
    currentTrialIndex = 0;
    for (int s = 0; s < setCount; s++) {
      currentSet = s;
      state = ActivityStateStroopTest.prepare;
      await _runSet(s);
    }
    _completed = true;
    return evaluate(trials);
  }

  Future<void> _runSet(int setIndex) async {
    for (int t = 0; t < trialPerSet; t++) {
      currentTrial = t;
      await _runTrial(setIndex, t);
    }
  }

  Future<void> _runTrial(int setIndex, int trialIndex) async {
    final index = setIndex * trialPerSet + trialIndex;
    final trial = trials[index];

    currentTrialIndex = index;

    // Get user input
    TrialResponse<Color> response = await _getUserInput();

    final TrialStroopTest completedTrial = trial.addResponse(response);
    trials[index] = completedTrial;
  }

  Future<TrialResponse<Color>> _getUserInput() async {
    // Await UI response
    _inputCompleter = Completer<TrialResponse<Color>>();

    return _inputCompleter!.future;
  }

  void submitAnswer(Color answer, Duration reactionTime) {
    if (_inputCompleter == null || _inputCompleter!.isCompleted) {
      return;
    }

    _inputCompleter!.complete(
      TrialResponse<Color>(
        answer: answer,
        reactionTime: reactionTime,
        timedOut: false,
      ),
    );
  }

  @override
  ActivityResultStroopTest evaluate(List<Trial> trials) {
    int correct = 0;

    double accuracy = 0;
    double averageReactionTime = 0;
    double rtConsistency = 0;
    double score = 0;

    double rtVariance = 0;
    double rtStandardDeviation = 0;
    double rtCoefficientOfVariation = 0;

    for (var trial in trials) {
      trial = trial as TrialStroopTest;
      final response = trial.response;

      if (response == null) throw StateError("Trial has no response");

      if (response.answer! == trial.displayColor) {
        correct++;
      }

      averageReactionTime += trial.response!.reactionTime!.inMilliseconds;
    }

    accuracy = (correct / trials.length) * 100;
    averageReactionTime /= trials.length;

    // Find CV for RT
    for (var trial in trials) {
      trial = trial as TrialStroopTest;
      final response = trial.response;

      if (response == null) throw StateError("Trial has no response");

      rtVariance += pow(
        (response.reactionTime!.inMilliseconds - averageReactionTime),
        2,
      );
    }

    rtStandardDeviation = sqrt(rtVariance / trials.length);
    rtCoefficientOfVariation = rtStandardDeviation / averageReactionTime;

    rtConsistency = rtCoefficientOfVariation;

    return ActivityResultStroopTest(
      correct: correct,
      accuracy: accuracy,
      averageReactionTime: averageReactionTime,
      rtConsistency: rtConsistency,
      score: score,
    );
  }

  List<Color> get allowedColor => colorSets[currentSet];
  Map<Color, String> get colorsName => _colorsName;
  bool get isCompleted => _completed;
}
