import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AttentionApp()));
}

class AttentionApp extends ConsumerWidget {
  const AttentionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
        )
      ),
    );
  }
}