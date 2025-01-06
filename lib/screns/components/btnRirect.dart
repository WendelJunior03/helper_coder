// ignore: file_names
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Btnrirect extends StatelessWidget {
  const Btnrirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final GlobalKey<SlideActionState> key = GlobalKey();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SlideAction(
            textColor: const Color.fromARGB(255, 255, 255, 255),
            innerColor: Colors.purple,
            outerColor: Colors.blue,
            sliderButtonIcon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            text: 'Arraste para Iniciar',
            key: key,
            onSubmit: () {
              Future.delayed(
                const Duration(seconds: 2),
                () => key.currentState!.reset(),
              );
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
