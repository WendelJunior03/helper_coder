import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper_coder/main.dart'; // Importe o MyAppState
import 'package:markdown_widget/markdown_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
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

      // Envia a mensagem via MyAppState, que salva automaticamente no SQLite
      await context.read<MyAppState>().addChat(userInput);

      // Pega o último chat salvo para exibir a resposta
      final lastChat = context.read<MyAppState>().chats.lastWhere(
            (chat) => chat.question == userInput,
            orElse: () => Chat(
              question: userInput,
              response: 'Erro ao obter resposta.',
              timestamp: DateTime.now(),
            ),
          );

      setState(() {
        _response = lastChat.response;
        _isLoading = false;
      });

      _controller.clear();
    }
  }

  void _copyToClipboard() {
    if (_response.isNotEmpty) {
      FlutterClipboard.copy(_response).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código copiado!')),
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
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Column(
          children: [
            Text(
              'iCoders',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        flexibleSpace: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 0, 0, 0)
                        .withOpacity(0.3 + _animationController.value * 0.2),
                    Colors.purple
                        .withOpacity(0.3 + _animationController.value * 0.2),
                    const Color.fromARGB(255, 113, 113, 113)
                        .withOpacity(0.3 + _animationController.value * 0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  transform:
                      GradientRotation(_animationController.value * 2 * 3.14159),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(134, 0, 0, 0).withOpacity(1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 42, 42, 42),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'M e n u',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('I n i c i o', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/tela_informacoes');
              },
            ),
            ListTile(
              title: const Text('H o m e', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/homePage');
              },
            ),
            ListTile(
              title: const Text('C h a t s', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/chats');
              },
            ),
          ],
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
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    MarkdownWidget(
                      data: _response.isNotEmpty
                          ? _response
                          : 'Olá, o que posso te ajudar hoje?',
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
                    if (_response.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Container(
                            width: 40,
                            height: 40,
                            color:
                                const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                            child: const Icon(
                              Icons.copy,
                              color: Color.fromARGB(255, 184, 184, 184),
                              size: 25,
                            ),
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
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => _sendMessage(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0), width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Digite aqui sua pergunta!',
                  labelStyle:
                      const TextStyle(color: Color.fromARGB(255, 67, 67, 67)),
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(255, 31, 31, 31)),
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