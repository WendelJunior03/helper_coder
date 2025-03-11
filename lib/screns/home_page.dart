import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:helper_coder/server/gemini_service.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// quando o usuário envia uma mensagem, a mensagem é enviada ao modelo de IA e a resposta é exibida na tela
class _HomePageState extends State<HomePage> {
  // o TextEditingController é usado para obter o texto digitado pelo usuário
  final TextEditingController _controller = TextEditingController();
  // o GeminiService é usado para enviar mensagens ao modelo de IA
  final GeminiService _geminiService = GeminiService();
  // a resposta do modelo de IA é armazenada no estado do widget
  String _response = '';

// o estado do widget também controla se a resposta está sendo carregada
  bool _isLoading = false;

  void _sendMessage() async {
    String userInput = _controller.text;
    if (userInput.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      String? response = await _geminiService.sendMessage(userInput);

      setState(() {
        _response = response ?? 'Erro ao obter resposta.';
        _isLoading = false;
      });

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'iCode',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: () => {},
          //   style: ButtonStyle(
          //     foregroundColor: MaterialStateProperty.all(
          //       const Color.fromARGB(255, 255, 255, 255),
          //     ),
          //   ),
          // ),
        ],
        flexibleSpace: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 0, 81, 255), const Color.fromARGB(255, 4, 0, 104)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 53, 53, 53).withOpacity(1),
                blurRadius: 3,
                spreadRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildResponseSection(),
          _buildInputSection(),
        ],
      ),
    );
  }

  // No widget de exibição de resposta:
  Widget _buildResponseSection() {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 300,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : MarkdownWidget(
                  data: _response.isNotEmpty
                      ? _response
                      : 'Olá, o que posso te ajudar hoje ?',
                  config: MarkdownConfig(
                    configs: [
                      PreConfig(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        theme: atomOneDarkTheme,
                        styleNotMatched: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 120, 140, 232),
                        ),
                      )
                    ],
                  ),
                  selectable: true,
                ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0), width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Digite aqui sua pergunta!',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send, color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}