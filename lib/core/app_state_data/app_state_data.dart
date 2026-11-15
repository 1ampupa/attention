import 'package:attention/core/assessments/assessment_session.dart';
import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/user/user.dart';

class AppStateData {

  final AppState state;
  final User? user;
  final AssessmentSession? session; 

  AppStateData({
    AppState? state,
    this.user,
    this.session
  }) :
    state = state ?? AppState.loading;

  AppStateData copyWith({
    AppState? state,
    User? user,
    AssessmentSession? session,
  }) {
    return AppStateData(
      state: state ?? this.state,
      user: user ?? this.user,
      session: session ?? this.session,
    );
  }

}