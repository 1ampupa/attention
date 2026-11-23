import 'package:attention/core/activities/stroop_test/activity_result_stroop_test.dart';
import 'package:attention/core/activities/stroop_test/activity_stroop_test.dart';
import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/providers/app_state_data_provider.dart';
import 'package:attention/gui/pages/countdown_page.dart';
import 'package:attention/gui/widgets/reaction_time_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityStroopTestPage extends ConsumerStatefulWidget {
  const ActivityStroopTestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ActivityStroopTestPageState();
}

class _ActivityStroopTestPageState
    extends ConsumerState<ActivityStroopTestPage> {
  @override
  Widget build(BuildContext context) {
    final activity =
        ref.read(appStateDataProvider).session?.currentActivity
            as ActivityStroopTest;
    if (activity.state == ActivityStateStroopTest.prepare) {
      return preparePage(activity);
    } else if (activity.state == ActivityStateStroopTest.countdown) {
      return CountdownPage(
        onComplete: () {
          setState(() {
            activity.state = ActivityStateStroopTest.ingame;
          });
        },
      );
    } else if (activity.isCompleted) {
      return resultPage(activity);
    } else {
      return gamePage(activity);
    }
  }

  Column preparePage(ActivityStroopTest activity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 20,
      children: [
        Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 15,
              children: [
                Text(
                  "SET ${(activity.currentSet + 1).toString()}/${(activity.setCount).toString()}",
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  "${(activity.trialPerSet).toString()} trials",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            Text(
              "Remember these set of buttons.\nThis ensure more accurate result of the test.",
            ),
          ],
        ),
        SizedBox(
          height: 250,
          child: Column(
            spacing: 10,
            children: [
              for (Color color in activity.colorSets[activity.currentSet])
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Text(
                    "${activity.colorsName[color]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
            ],
          ),
        ),
        Text("Once you're ready, press START"),
        ElevatedButton(
          onPressed: () {
            setState(() {
              activity.state = ActivityStateStroopTest.countdown;
            });
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(300, 50),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Text(
            "START",
            style: TextStyle(fontFamily: "Anton", fontSize: 30),
          ),
        ),
      ],
    );
  }

  Column gamePage(ActivityStroopTest activity) {
    final stopwatch = Stopwatch()..start();
    return Column(
      spacing: 10,
      children: [
        Text(
          "Set ${activity.currentSet + 1} Trial ${activity.currentTrial + 1}",
        ),
        Container(
          constraints: BoxConstraints.tight(Size(300, 150)),
          child: Center(
            child: Text(
              "${activity.colorsName[activity.trials[activity.currentTrialIndex].wordColor]}",
              style: TextStyle(
                color: activity.trials[activity.currentTrialIndex].displayColor,
                fontFamily: "Anton",
                fontSize: 60,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: Column(
            spacing: 10,
            children: [
              for (Color color in activity.colorSets[activity.currentSet])
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activity.submitAnswer(color, stopwatch.elapsed);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Text(
                    "${activity.colorsName[color]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // TODO Stroop Test Result Page
  Column resultPage(ActivityStroopTest activity) {
    final ActivityResultStroopTest? result = activity.result;
    if (result == null) {
      throw StateError("There's no result of this activity");
    }
    final double rtConsistencyAdjusted = 100 - (result.rtConsistency * 100);
    List<int> reactionTimeData = [];
    for (var trial in activity.trials) {
      reactionTimeData.add(trial.response!.reactionTime!.inMilliseconds);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 150,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("RESULT", style: TextStyle(fontFamily: "Anton", fontSize: 50)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Answer Accuracy"),
                Text(
                  "${result.accuracy.toStringAsPrecision(4)}% (${result.correct}/${activity.trials.length})",
                ),
              ],
            ),
            // for (var trial in activity.trials)
            //   Builder(builder: (context) {
            //     debugPrint("${trial.response!.reactionTime!.inMilliseconds}");
            //     return Text("${trial.response!.reactionTime!.inMilliseconds}");
            //   },),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Average Reaction Time"),
                Text("${result.averageReactionTime.toStringAsPrecision(5)} ms"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Reaction Time Consistency"),
                Text("${rtConsistencyAdjusted.toStringAsPrecision(4)}%"),
              ],
            ),
            ReactionTimeChart(reactionTimes: reactionTimeData)
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [           
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ref.read(appStateDataProvider.notifier).setState(AppState.home);
                });
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                "CONTINUE",
                style: TextStyle(fontSize: 30, fontFamily: "Anton"),
              ),
            ),
          ],
        ),        
      ],
    );
  }
}
