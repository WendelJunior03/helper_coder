import 'package:flutter/material.dart';
import 'package:helper_coder/screns/tela_informacoes.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Telainformacoe(),
      ),
    );
  }
}