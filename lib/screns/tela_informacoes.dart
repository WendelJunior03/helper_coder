import 'package:flutter/material.dart';
import 'package:helper_coder/screns/components/btnRirect.dart';

class Telainformacoe extends StatefulWidget {
  const Telainformacoe({super.key});

  @override
  State<Telainformacoe> createState() => _TelainformacoeState();
}

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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Animação de fundo
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.withOpacity(0.3 + controller.value * 0.2),
                        Colors.purple.withOpacity(0.3 + controller.value * 0.2),
                        Colors.blueAccent.withOpacity(0.3 + controller.value * 0.2),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      transform: GradientRotation(controller.value * 2 * 3.14159),
                    ),
                  ),
                );
              },
            ),
            // Conteúdo original
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Btnrirect(text: ''),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}