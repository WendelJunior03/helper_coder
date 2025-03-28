// ignore: file_names
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/components/inputName.dart';
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
          child: Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('<iCoders/>', style: TextStyle(
                  color: Color.fromARGB(255, 222, 222, 222),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 20.0),
                Text('Bem-vindo ao Intelligent Coders!', style: TextStyle(
                  color: Color.fromARGB(255, 222, 222, 222),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 30.0),
                InputName(),
                //Corpo do botao de arrastar.
            
                // const SizedBox(height: 20.0),
                // SlideAction(
                //   textColor: const Color.fromARGB(255, 255, 255, 255),
                //   innerColor: const Color.fromARGB(255, 255, 255, 255),
                //   outerColor: const Color.fromARGB(255, 28, 28, 28),
                //   sliderButtonIcon: const Icon(
                //     Icons.arrow_forward,
                //     color: Color.fromARGB(255, 0, 0, 0),
                //   ),
                //   text: 'Arraste para Iniciar',
                //   key: key,
                //   onSubmit: () {
                //     Future.delayed(
                //       const Duration(seconds: 2),
                //       () => key.currentState!.reset(),
                //     );
                //     return Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const HomePage(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
