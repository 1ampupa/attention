import 'dart:async';

import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  final VoidCallback onComplete;

  const CountdownPage({super.key, required this.onComplete});

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with SingleTickerProviderStateMixin {
  int countdown = 3;
  bool isGo = false;

  late final AnimationController controller;
  late final Animation<double> scale;
  late final Animation<double> opacity;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    scale = Tween<double>(
      begin: 0.25,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    _startCountdown();
  }

  void _startCountdown() {
    controller.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (countdown > 1) {
        setState(() => countdown--);
        controller.forward(from: 0);
      } else if (!isGo) {
        setState(() => isGo = true);
        controller.forward(from: 0);
      } else {
        timer.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Opacity(
            opacity: opacity.value,
            child: Transform.scale(scale: scale.value, child: child),
          );
        },
        child: Text(
          isGo ? "GO!" : countdown.toString(),
          style: TextStyle(
            fontFamily: "Anton",
            fontSize: 120,
            color: isGo
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
