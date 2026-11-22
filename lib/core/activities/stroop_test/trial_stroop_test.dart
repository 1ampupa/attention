import 'package:attention/core/activities/trial.dart';
import 'package:attention/core/activities/trial_response.dart';
import 'package:flutter/material.dart';

class TrialStroopTest extends Trial<Color> {
  final Color wordColor;
  final Color displayColor;

  TrialStroopTest({
    required this.wordColor,
    required this.displayColor,
    super.response,
  });

  @override
  TrialStroopTest addResponse(TrialResponse<Color> response) {
    return TrialStroopTest(
      displayColor: displayColor,
      wordColor: wordColor,
      response: response,
    );
  }
}