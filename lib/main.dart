import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';
import 'package:helper_coder/screns/my_home_page.dart';
import 'package:helper_coder/screns/tela_informacoes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), // Instância de MyAppState
      child: MaterialApp(
        title: 'Helper Coder',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
          ),
        ),
        home: MyHomePage(), 
        routes: {
        '/tela_informacoes': (context) => const Telainformacoe(),
        '/homePage': (context) => const HomePage(),

      },// Tela inicial
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Modelo para gerenciar o estado da aplicação
class MyAppState extends ChangeNotifier {
  // Variável para armazenar a palavra atual
  var current = WordPair.random();

  // Método para atualizar a palavra
  void getNext() {
    current = WordPair.random();
    notifyListeners(); // Notifica os widgets que dependem deste estado
  }
}
