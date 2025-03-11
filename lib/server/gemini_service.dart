import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;
  final List<Content> _chatHistory = [];

// a classe GeminiService é responsável por gerenciar a comunicação com o modelo de IA e manter o histórico de conversas
  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: 'AIzaSyAZK-JYMWQS1gyrhpD2n3FYHBIQyu-cxIQ',
          generationConfig: GenerationConfig(maxOutputTokens: 1000),
        ) {
    // Inicialize a conversa com a primeira interação
    _chatHistory.addAll([
      Content.text(
          'Você é uma IA especialista em desenvolvimento de software?'),
      Content.model([
        TextPart(
            'Sou um especialista em desenvolvimento de software e estou aqui para ajudar você!'),
        TextPart(
            'Tenho experiência em diversas linguagens de programação, incluindo Dart, Python, JavaScript, e mais.'),
        TextPart('Como posso ajudar você hoje?'),
      ]),
    ]);
  }

// o método sendMessage é responsável por enviar a mensagem do usuário ao modelo de IA e obter uma resposta gerada
  Future<String?> sendMessage(String userInput) async {
    // Adiciona a mensagem do usuário ao histórico
    _chatHistory.add(Content.text(userInput));

    // Envia a mensagem ao modelo e obtém a resposta
    final chat = _model.startChat(history: _chatHistory);
    // Enviando a mensagem do usuário ao modelo
    final response = await chat.sendMessage(Content.text(userInput));

    // Tratando a resposta para extrair o texto gerado
    // ignore: unnecessary_null_comparison
    if (response != null && response is Content) {
      _chatHistory.add(Content.text(response.text!));
      return response.text; // Retorna o texto gerado
      // ignore: unnecessary_null_comparison
    } else if (response != null && response.text != null) {
      // Caso o objeto retornado não seja diretamente um `Content`, tratamos o texto
      final generatedContent = Content.text(response.text!);
      _chatHistory.add(generatedContent);
      return response.text!;
    }

    // Caso não haja resposta válida
    return 'Erro: Resposta inesperada do modelo.';
  }
}
