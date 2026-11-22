import 'package:attention/core/activities/stroop_test/activity_stroop_test.dart';
import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/providers/app_state_data_provider.dart';
import 'package:attention/gui/pages/activities/stroop_test/activity_stroop_test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InSessionPage extends ConsumerWidget {
  const InSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Row(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(appStateDataProvider.notifier)
                        .setState(AppState.selectActivity);
                  },
                  child: Text("X"),
                ),
                Text("${ref.read(appStateDataProvider).session?.currentActivity.name.toString()}"),
              ],
            ),
            Builder(
              builder: (context) {
                final session = ref.read(appStateDataProvider).session;
                if (session == null) return fallbackPage("No session");

                final activity = session.currentActivity;

                return switch (activity) {
                  ActivityStroopTest _ => ActivityStroopTestPage(),
                  _ => fallbackPage("Unknown activity"),
                };
              },
            ),
            Column()
          ],
        ),
      ),
    );
  }

  Column fallbackPage(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text(errorMessage)],
    );
  }
}
