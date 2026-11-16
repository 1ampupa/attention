import 'package:attention/core/assessments/assessment_session.dart';
import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/user/user.dart';

class AppStateData {
  static const _undefined = Object();

  final AppState state;
  final User? user;
  final AssessmentSession? session;

  AppStateData({AppState? state, this.user, this.session})
    : state = state ?? AppState.loading;

  AppStateData copyWith({
    AppState? state,
    Object? user = _undefined,
    Object? session = _undefined,
  }) {
    return AppStateData(
      state: state ?? this.state,
      user: identical(user, _undefined) ? this.user : user as User?,
      session: identical(session, _undefined)
          ? this.session
          : session as AssessmentSession?,
    );
  }
}
