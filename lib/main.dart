import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';
import 'package:helper_coder/screns/tela_informacoes.dart';
import 'package:helper_coder/screns/chats.dart';
import 'package:helper_coder/server/gemini_service.dart';
import 'package:provider/provider.dart';

class Chat {
  final int? id;
  final String question;
  final String response;
  final DateTime timestamp;

  Chat({
    this.id,
    required this.question,
    required this.response,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'response': response,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'],
        question: json['question'],
        response: json['response'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  final GeminiService _geminiService = GeminiService();
  bool _isInitialized = false;

  MyAppState() {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await loadChats();
    _isInitialized = true;
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  Future<void> addChat(String question) async {
    if (!_isInitialized) return;
    final response = await _geminiService.sendMessage(question);
    if (response != null) {
      await loadChats();
    }
  }

  Future<void> loadChats() async {
    try {
      chats = (await _geminiService.getChats()).cast<Chat>();
    } catch (e) {
      print('Erro ao carregar chats: $e');
      chats = [];
    }
    notifyListeners();
  }
}