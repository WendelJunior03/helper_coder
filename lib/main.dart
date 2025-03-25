import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';
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
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'iCode',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
          ),
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: const Telainformacoe(), // Mudei para Telainformacoe
        routes: {
          '/tela_informacoes': (context) => const Telainformacoe(),
          '/homePage': (context) => const HomePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}