import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper_coder/server/gemini_service.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:clipboard/clipboard.dart'; // Importe a biblioteca clipboard

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  String _response = '';
  bool _isLoading = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(milliseconds: 4000),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) _animationController.reverse();
        if (status == AnimationStatus.dismissed) _animationController.forward();
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

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

  // Método para copiar o texto para a área de transferência
  void _copyToClipboard() {
    if (_response.isNotEmpty) {
      FlutterClipboard.copy(_response).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código copiado para a área de transferência!')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'iCode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        flexibleSpace: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.3 + _animationController.value * 0.2),
                    Colors.purple.withOpacity(0.3 + _animationController.value * 0.2),
                    Colors.blueAccent.withOpacity(0.3 + _animationController.value * 0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  transform: GradientRotation(_animationController.value * 2 * 3.14159),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(134, 0, 0, 0).withOpacity(1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            );
          },
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

  Widget _buildResponseSection() {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          height: 300,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    MarkdownWidget(
                      data: _response.isNotEmpty
                          ? _response
                          : 'Olá, o que posso te ajudar hoje ?',
                      config: MarkdownConfig(
                        configs: [
                          PreConfig(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 28, 28, 28),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            theme: atomOneDarkTheme,
                            styleNotMatched: TextStyle(
                              fontFamily: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ).fontFamily,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          )
                        ],
                      ),
                      selectable: true,
                    ),
                    // Botão de copiar no canto superior direito
                    if (_response.isNotEmpty) // Só exibe o botão se houver resposta
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _copyToClipboard,
                          tooltip: 'Copiar código',
                        ),
                      ),
                  ],
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
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 67, 67, 67)),
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send, color: const Color.fromARGB(255, 31, 31, 31)),
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