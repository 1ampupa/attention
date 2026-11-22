import 'package:attention/core/activities/stroop_test/activity_stroop_test.dart';
import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/providers/app_state_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugActivityChooserPage extends ConsumerWidget {
  const DebugActivityChooserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(30),
        child: Column(
          spacing: 20,
          children: [
            Row(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(appStateDataProvider.notifier)
                        .setState(AppState.home);
                  },
                  child: Text("<"),
                ),
                Text("DEBUG: Choose an activity"),
              ],
            ),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(500, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                "Target Detection Test",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(500, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                "Continuous Performance Test",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final activity = ActivityStroopTest();
                ref.read(appStateDataProvider.notifier).setSession([
                  activity
                ]);
                ref
                    .read(appStateDataProvider.notifier)
                    .setState(AppState.inSession);
                activity.prepare();
                await activity.start();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(500, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text("Stroop Test", style: TextStyle(fontSize: 20)),
            ),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(500, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                "Task switching Test",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(500, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text("Dual-task Test", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
