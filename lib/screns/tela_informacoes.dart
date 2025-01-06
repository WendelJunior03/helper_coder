import 'package:flutter/material.dart';
import 'package:helper_coder/screns/components/btnRirect.dart';
import 'package:helper_coder/screns/components/emailPassword.dart';

class Telainformacoe extends StatefulWidget {
  const Telainformacoe({super.key});

  @override
  State<Telainformacoe> createState() => _TelainformacoeState();
}

// https://pub.dev/packages/sidebarx - implementar sidebar
class _TelainformacoeState extends State<Telainformacoe>
    with SingleTickerProviderStateMixin {
  bool up = true;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(milliseconds: 4000),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) controller.reverse();
        if (status == AnimationStatus.dismissed) controller.forward();
      });

    controller.forward();
  }

  @override
  void dispose() {
    // Dispose of the AnimationController
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: EmailPasswordWidget(),
          ),
          const SizedBox(height: 20),
          Btnrirect(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
