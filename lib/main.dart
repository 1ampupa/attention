import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attention/core/app_state_data/app_state_data.dart';
import 'package:attention/core/enums/app_state.dart';
import 'package:attention/core/providers/app_state_data_provider.dart';

import 'package:attention/gui/pages/home_page.dart';
import 'package:attention/gui/pages/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  runApp(ProviderScope(child: AttentionApp()));
}

class AttentionApp extends ConsumerStatefulWidget {
  const AttentionApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AttentionAppState();
}

class _AttentionAppState extends ConsumerState<AttentionApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => ref.read(appStateDataProvider.notifier).initialize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStateData appData = ref.watch(appStateDataProvider);
    final AppState appState = appData.state;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Attention",

      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        fontFamily: 'IBM Plex Sans Thai',

        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF151515),
          primary: Color(0xFF7555FF),
          primaryContainer: Color(0xFF7555FF),
          onPrimary: Color(0xFFDBE7FF),
          secondary: Color(0xFFDBE7FF),
          secondaryContainer: Color(0xFFDBE7FF),
          onSecondary: Color(0xFF151515),
          tertiary: Color(0xFF202020),
          tertiaryContainer: Color(0xFF202020),
          onTertiary: Color(0xFFDBE7FF),
          onTertiaryContainer: Color(0xFFDBE7FF),
        ),

        tooltipTheme: const TooltipThemeData(
          preferBelow: false,
          waitDuration: Duration(milliseconds: 500),
        ),
      ),

      home: switch (appState) {
        AppState.loading => const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [CircularProgressIndicator(), Text("Please wait...")],
            ),
          ),
        ),
        AppState.home => HomePage(),
        AppState.welcome => SignInPage(),
        AppState.createUser => SignInPage(),
      },
    );
  }
}
