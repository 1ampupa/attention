import 'package:attention/core/activities/trial_response.dart';

abstract class Trial<T> {
  final TrialResponse<T>? response;

  Trial({
    required this.response
  });

  Trial<T> addResponse(TrialResponse<T> response);
}
