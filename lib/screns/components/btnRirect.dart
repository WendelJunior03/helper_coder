// ignore: file_names
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Btnrirect extends StatefulWidget {
  const Btnrirect({super.key, required String text});

  @override
  State<Btnrirect> createState() => _BtnrirectState();
}

class _BtnrirectState extends State<Btnrirect> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final GlobalKey<SlideActionState> key = GlobalKey();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Bem-vindo ao Intelligent Coders!', style: TextStyle(
                color: const Color(0xFF000000),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20.0),
              SlideAction(
                textColor: const Color.fromARGB(255, 255, 255, 255),
                innerColor: const Color.fromARGB(255, 255, 255, 255),
                outerColor: const Color.fromARGB(255, 0, 0, 0),
                sliderButtonIcon: const Icon(
                  Icons.arrow_forward,
                  color: Color.fromARGB(255, 0, 0, 0),
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
            ],
          ),
        );
      },
    );
  }
}
