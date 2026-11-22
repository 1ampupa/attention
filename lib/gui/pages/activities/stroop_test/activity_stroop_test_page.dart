import 'package:attention/core/activities/stroop_test/activity_stroop_test.dart';
import 'package:attention/core/providers/app_state_data_provider.dart';
import 'package:attention/gui/pages/countdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityStroopTestPage extends ConsumerStatefulWidget {
  const ActivityStroopTestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ActivityStroopTestPageState();
}

class _ActivityStroopTestPageState extends ConsumerState<ActivityStroopTestPage> {

  @override
  Widget build(BuildContext context) {
    final activity =
        ref.read(appStateDataProvider).session?.currentActivity
            as ActivityStroopTest;
    if (activity.state == ActivityStateStroopTest.prepare) {
      return preparePage(activity);
    } else if (activity.state == ActivityStateStroopTest.countdown) {
      return CountdownPage(onComplete: () {
        setState(() {
          activity.state = ActivityStateStroopTest.ingame;
        });
      });
    } else if (activity.isCompleted) {
      return resultPage();
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
                Text(
                  "${(activity.colorSets[activity.currentSet].length).toString()} colours",
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
          height: 350,
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
          color: activity.trials[activity.currentTrialIndex].displayColor,
          constraints: BoxConstraints.tight(Size(300, 300)),
          child: Center(
            child: Text(
              "${activity.colorsName[activity.trials[activity.currentTrialIndex].wordColor]}",
              style: TextStyle(
                color:
                    activity.trials[activity.currentTrialIndex].displayColor ==
                        Colors.yellow
                    ? Theme.of(context).colorScheme.tertiary
                    : Colors.white,
                fontFamily: "Anton",
                fontSize: 60,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 350,
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
  Column resultPage() {
    return Column(
      children: [
        Icon(Icons.check, size: 100,),
        Text("game finished yay yay")
      ],
    );
  }
}
