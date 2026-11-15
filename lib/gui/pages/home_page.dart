import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/providers/app_state_data_provider.dart';
import 'package:attention/core/user/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        minimum: EdgeInsets.all(20),
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
                      onSelected: (value) {
                        if (value == "reset") {
                          UserStorage.delete();
                          ref.read(appStateDataProvider.notifier).setUser(null);
                          ref
                              .read(appStateDataProvider.notifier)
                              .setState(AppState.createUser);
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
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Text(
                        "Your score",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        ref.read(appStateDataProvider).user?.metrics.currentASScore.toString() ?? "???",
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: "Anton"
                        ),
                      )
                    ],
                  ),
                ))
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
                        textStyle: TextStyle(fontSize: 70, fontFamily: "Anton"),
                      ),
                      child: Text("ASSESS"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        textStyle: TextStyle(fontSize: 70, fontFamily: "Anton"),
                      ),
                      child: Text("PRACTICE"),
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
