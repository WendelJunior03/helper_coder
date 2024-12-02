import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';

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
          SizedBox(
            height: 300,
            width: double.infinity,
            child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0.0, -0.1),
                        end: const Offset(0.0, -0.24))
                    .animate(controller),
                child:
                    Image.asset(('lib/assets/images/IAAmigavel-semfundo.png'))),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 189, 223, 238)),
            child: Text(
              'Sou sua assistente virtual, estou aqui para ajudar você a encontrar informações sobre desenvolvimento de software. \n \n Click no botão abaixo para começar!',
              style: const TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
              child: ElevatedButton(
                onPressed: () {
                  // Navegar de volta para HomePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text('Começar',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
