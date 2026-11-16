import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attention/core/providers/app_state_data_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String get greetMessage {
    DateTime time = DateTime.now();
    if (time.hour >= 0 && time.hour <= 12) {
      return "Good morning";
    } else if (time.hour >= 13 && time.hour <= 17) {
      return "Good afternoon";
    } else if (time.hour >= 18 && time.hour <= 23) {
      return "Good evening";
    } else {
      return "Hello";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    PopupMenuButton(
                      onSelected: (value) async {
                        if (value == "reset") {
                          ref.read(appStateDataProvider.notifier).resetUser();
                        }
                      },
                      icon: const Icon(Icons.person),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        iconColor: Theme.of(context).colorScheme.secondary,
                      ),
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: "view",
                          child: Text("View profile"),
                        ),
                        const PopupMenuItem(
                          value: "reset",
                          child: Text(
                            "Reset user",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "$greetMessage, ${ref.read(appStateDataProvider).user?.profile.displayName}.",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Text(
                  "ATTENTION",
                  style: TextStyle(fontFamily: "Anton", fontSize: 50),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Text("AS Score", style: TextStyle(fontSize: 20)),
                        Text(
                          ref
                                  .read(appStateDataProvider)
                                  .user
                                  ?.metrics
                                  .currentASScore
                                  .toString() ??
                              "???",
                          style: TextStyle(fontSize: 35, fontFamily: "Anton"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        textStyle: TextStyle(fontSize: 65, fontFamily: "Anton"),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ASSESS"),
                          Text(
                            "Evaluate your AS (Attention Score) using certain designed activities.\nEstimated time: 10 - 15 minutes",
                            style: TextStyle(
                              fontFamily: "IBM Plex Sans Thai",
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        textStyle: TextStyle(fontSize: 65, fontFamily: "Anton"),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("PRACTICE"),
                          Text(
                            "Train your attention span at anytime from anywhere without messing with your AS (Attention Score).\nEstimated time: 3 - 5 minutes",
                            style: TextStyle(
                              fontFamily: "IBM Plex Sans Thai",
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
