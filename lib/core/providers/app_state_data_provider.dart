import 'package:attention/core/activities/activity.dart';
import 'package:attention/core/app_state_data/app_state_data.dart';
import 'package:attention/core/assessments/assessment_session.dart';
import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/user/user.dart';
import 'package:attention/core/user/user_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStateDataProvider extends Notifier<AppStateData> {
  @override
  AppStateData build() => AppStateData();

  Future<void> initialize() async {
    final user = await UserStorage.load();

    state = state.copyWith(
      user: user,
      state: user == null ? AppState.welcome : AppState.home,
    );
  }

  void setState(AppState appState) {
    state = state.copyWith(state: appState);
  }

  void setUser(User? user) {
    state = state.copyWith(user: user);
  }

  Future<void> resetUser() async {
    state = state.copyWith(state: AppState.loading, user: null);

    await UserStorage.delete();

    state = state.copyWith(state: AppState.createUser);
  }
  
  void setSession(List<Activity> activities) {
    state = state.copyWith(session: AssessmentSession(activities: activities));
  }
}

final appStateDataProvider =
    NotifierProvider<AppStateDataProvider, AppStateData>(
      AppStateDataProvider.new,
    );
