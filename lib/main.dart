import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';
import 'package:helper_coder/screns/tela_informacoes.dart';
import 'package:helper_coder/screns/chats.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Chat {
  final String question;
  final String response;
  final DateTime timestamp;

  Chat({required this.question, required this.response, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'question': question,
        'response': response,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        question: json['question'],
        response: json['response'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o binding esteja inicializado
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: const Telainformacoe(),
        routes: {
          '/tela_informacoes': (context) => const Telainformacoe(),
          '/homePage': (context) => const HomePage(),
          '/chats': (context) => const Chats(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  List<Chat> chats = [];
  bool _isInitialized = false;

  MyAppState() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Aguarda um pequeno delay para garantir que o plugin esteja pronto
    await Future.delayed(const Duration(milliseconds: 100));
    await loadChats();
    _isInitialized = true;
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void addChat(String question, String response) {
    if (!_isInitialized) return;
    chats.add(Chat(
      question: question,
      response: response,
      timestamp: DateTime.now(),
    ));
    _saveChats();
    notifyListeners();
  }

  Future<void> loadChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? chatsJson = prefs.getString('chats');
      if (chatsJson != null) {
        final List<dynamic> decoded = jsonDecode(chatsJson);
        chats = decoded.map((chat) => Chat.fromJson(chat)).toList();
      }
    } catch (e) {
      print('Erro ao carregar chats: $e');
      chats = []; // Define uma lista vazia em caso de erro
    }
    notifyListeners();
  }

  Future<void> _saveChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(chats.map((chat) => chat.toJson()).toList());
      await prefs.setString('chats', encoded);
    } catch (e) {
      print('Erro ao salvar chats: $e');
    }
  }
}