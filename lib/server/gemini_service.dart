import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:helper_coder/main.dart'; // Para acessar a classe Chat

class GeminiService {
  final GenerativeModel _model;
  final List<Content> _chatHistory = [];
  Database? _database;

  GeminiService() : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: 'Coloque Sua Chave API aqui', // Substitua pela sua chave
          generationConfig: GenerationConfig(maxOutputTokens: 1000),
        ) {
    _initializeDatabase().then((_) {
      _loadInitialChatHistory();
    });
  }

  Future<void> _initializeDatabase() async {
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'chat_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE chats(id INTEGER PRIMARY KEY AUTOINCREMENT, question TEXT, response TEXT, timestamp TEXT)',
          );
        },
        version: 1,
      );
    } catch (e) {
      print('Erro ao inicializar o banco de dados: $e');
    }
  }

  Future<void> _loadInitialChatHistory() async {
    _chatHistory.addAll([
      Content.text('Você é uma IA especialista em desenvolvimento de software?'),
      Content.model([
        TextPart('Sou um especialista em desenvolvimento de software e estou aqui para ajudar você!'),
        TextPart('Tenho experiência em diversas linguagens de programação, incluindo Dart, Python, JavaScript, e mais.'),
        TextPart('Como posso ajudar você hoje?'),
      ]),
    ]);
  }

  Future<void> saveChat(String question, String response) async {
    if (_database == null) {
      await _initializeDatabase();
    }
    await _database!.insert(
      'chats',
      Chat(
        question: question,
        response: response,
        timestamp: DateTime.now(),
      ).toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Chat>> getChats() async {
    if (_database == null) {
      await _initializeDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query('chats');
    return List.generate(maps.length, (i) => Chat.fromJson(maps[i]));
  }

  Future<String?> sendMessage(String userInput) async {
    _chatHistory.add(Content.text(userInput));
    final chat = _model.startChat(history: _chatHistory);
    final response = await chat.sendMessage(Content.text(userInput));

    if (response.text != null) {
      final generatedContent = Content.model([TextPart(response.text!)]);
      _chatHistory.add(generatedContent);
      await saveChat(userInput, response.text!);
      return response.text;
    }
    return 'Erro: Resposta inesperada do modelo.';
  }
}