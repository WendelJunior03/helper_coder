import 'package:flutter/material.dart'; 
import 'package:flutter_highlight/themes/atom-one-dark.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:helper_coder/main.dart'; 
import 'package:markdown_widget/markdown_widget.dart'; 
import 'package:provider/provider.dart'; 

// Declaração da classe Chats como um widget com estado (StatefulWidget)
class Chats extends StatefulWidget {
  const Chats({super.key}); 

  @override
  State<Chats> createState() => _ChatsState(); // Cria o estado associado ao widget
}

// Classe de estado para o widget Chats, usando SingleTickerProviderStateMixin para animações
class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Controlador para animação do AppBar

  @override
  void initState() {
    super.initState(); // Chama o initState da classe pai
    // Inicializa o controlador de animação para o gradiente do AppBar
    _animationController = AnimationController(
      vsync: this, // Usa o mixin para sincronizar a animação com o frame rate
      duration: const Duration(seconds: 3), // Duração da animação (ida)
      reverseDuration: const Duration(milliseconds: 4000), // Duração da animação (volta)
    )..addStatusListener((AnimationStatus status) {
        // Listener para controlar o ciclo da animação
        if (status == AnimationStatus.completed) _animationController.reverse(); // Se completar, reverte
        if (status == AnimationStatus.dismissed) _animationController.forward(); // Se reverter, avança
      });

    _animationController.forward(); // Inicia a animação ao carregar a tela
  }

  @override
  void dispose() {
    _animationController.dispose(); // Libera o controlador de animação para evitar vazamentos de memória
    super.dispose(); // Chama o dispose da classe pai
  }

  // Função para exibir um modal (BottomSheet) com os detalhes de um chat
  void _showChatDetails(BuildContext context, Chat chat) {
    showModalBottomSheet(
      context: context, // Contexto necessário para construir o modal
      isScrollControlled: true, // Permite que o modal ajuste dinamicamente sua altura
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bordas arredondadas no topo
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, // Não expande automaticamente para tela cheia
          initialChildSize: 0.6, // Altura inicial do modal (60% da tela)
          maxChildSize: 0.9, // Altura máxima (90% da tela)
          minChildSize: 0.4, // Altura mínima (40% da tela)
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0), // Espaçamento interno do conteúdo
              child: ListView(
                controller: scrollController, // Usa o controlador de rolagem do DraggableScrollableSheet
                shrinkWrap: true, // Faz o ListView ajustar seu tamanho ao conteúdo, evitando expansão infinita
                physics: const ClampingScrollPhysics(), // Evita overscroll (comportamento padrão do Android)
                children: [
                  // Puxador visual centralizado no topo do modal
                  Center(
                    child: Container(
                      width: 40, // Largura do puxador
                      height: 5, // Altura do puxador
                      margin: const EdgeInsets.only(bottom: 10), // Margem inferior
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Cor cinza clara
                        borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Espaço vertical entre widgets
                  // Título "Pergunta" estilizado com o tema do app
                  Text(
                    'Pergunta',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold, // Texto em negrito
                        ),
                  ),
                  const SizedBox(height: 8), // Espaço vertical
                  // Widget para exibir a pergunta em Markdown com altura limitada
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1, // Limita a altura a 10% da tela
                    child: MarkdownWidget(
                      data: chat.question, // Conteúdo da pergunta do chat
                      config: MarkdownConfig(
                        configs: [
                          PreConfig(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 28, 28, 28), // Fundo escuro para blocos de código
                              borderRadius: BorderRadius.circular(15), // Bordas arredondadas
                            ),
                            theme: atomOneDarkTheme, // Tema escuro para destacar código
                            styleNotMatched: TextStyle(
                              fontFamily: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ).fontFamily, // Usa a fonte Roboto
                              fontWeight: FontWeight.w600, // Peso da fonte
                              color: const Color.fromARGB(255, 255, 255, 255), // Texto branco
                            ),
                          ),
                        ],
                      ),
                      selectable: true, // Permite selecionar o texto
                    ),
                  ),
                  const SizedBox(height: 20), // Espaço vertical maior
                  // Título "Resposta" estilizado com o tema do app
                  Text(
                    'Resposta',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold, // Texto em negrito
                        ),
                  ),
                  const SizedBox(height: 8), // Espaço vertical
                  // Widget para exibir a resposta em Markdown com altura limitada
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5, // Limita a altura a 50% da tela
                    child: MarkdownWidget(
                      data: chat.response, // Conteúdo da resposta do chat
                      config: MarkdownConfig(
                        configs: [
                          PreConfig(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 28, 28, 28), // Fundo escuro para blocos de código
                              borderRadius: BorderRadius.circular(15), // Bordas arredondadas
                            ),
                            theme: atomOneDarkTheme, // Tema escuro para destacar código
                            styleNotMatched: TextStyle(
                              fontFamily: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ).fontFamily, // Usa a fonte Roboto
                              fontWeight: FontWeight.w600, // Peso da fonte
                              color: const Color.fromARGB(255, 255, 255, 255), // Texto branco
                            ),
                          ),
                        ],
                      ),
                      selectable: true, // Permite selecionar o texto
                    ),
                  ),
                  const SizedBox(height: 10), // Espaço vertical
                  // Exibição da data e hora do chat
                  Text(
                    'Data: ${chat.timestamp.day}/${chat.timestamp.month}/${chat.timestamp.year} ${chat.timestamp.hour}:${chat.timestamp.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey), // Texto em cinza
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usa o Consumer para acessar o estado global (MyAppState) via Provider
    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: Colors.white, // Cor de fundo da tela
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Fundo transparente para o gradiente
            iconTheme: const IconThemeData(color: Colors.white), // Cor dos ícones do AppBar
            elevation: 0, // Remove sombra do AppBar
            title: const Column(
              children: [
                Text(
                  'Chats', // Título da tela
                  style: TextStyle(
                    color: Colors.white, // Cor do texto
                    fontSize: 30, // Tamanho da fonte
                    fontWeight: FontWeight.bold, // Negrito
                  ),
                ),
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)), // Bordas arredondadas do AppBar
            ),
            flexibleSpace: AnimatedBuilder(
              // Widget para criar o gradiente animado no fundo do AppBar
              animation: _animationController, // Usa o controlador de animação
              builder: (context, child) {
                return Container(
                  width: double.infinity, // Ocupa toda a largura
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle, // Forma retangular
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(15)), // Bordas arredondadas na parte inferior
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, // Início do gradiente
                      end: Alignment.bottomRight, // Fim do gradiente
                      colors: [
                        const Color.fromARGB(255, 0, 0, 0) // Cor preta
                            .withOpacity(0.3 + _animationController.value * 0.2),
                        Colors.purple // Cor roxa
                            .withOpacity(0.3 + _animationController.value * 0.2),
                        const Color.fromARGB(255, 113, 113, 113) // Cor cinza
                            .withOpacity(0.3 + _animationController.value * 0.2),
                      ],
                      stops: const [0.0, 0.5, 1.0], // Pontos de parada do gradiente
                      transform: GradientRotation(
                          _animationController.value * 2 * 3.14159), // Rotação animada
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(134, 0, 0, 0).withOpacity(1), // Cor da sombra
                        blurRadius: 3, // Desfoque da sombra
                        spreadRadius: 1, // Espalhamento da sombra
                        offset: const Offset(0, 1), // Deslocamento da sombra
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: Container(
            color: Colors.white, // Cor de fundo do corpo
            child: appState.chats.isEmpty
                ? const Center(
                    child: Text('Nenhum chat salvo ainda.')) // Mensagem se não houver chats
                : ListView.builder(
                    // Lista rolável para exibir os chats salvos
                    shrinkWrap: true, // Ajusta o tamanho ao conteúdo, evitando expansão infinita
                    physics: const AlwaysScrollableScrollPhysics(), // Mantém a rolagem ativa
                    itemCount: appState.chats.length, // Número de itens na lista
                    itemBuilder: (context, index) {
                      final chat = appState.chats[index]; // Acessa o chat atual
                      return ListTile(
                        title: Text(chat.question), // Exibe a pergunta como título
                        subtitle: Text(
                          chat.response.length > 50 // Limita a resposta a 50 caracteres no subtítulo
                              ? '${chat.response.substring(0, 50)}...' // Adiciona "..." se for maior
                              : chat.response, // Mostra completa se menor
                        ),
                        trailing: Text(
                          // Exibe a hora do chat
                          '${chat.timestamp.hour.toString().padLeft(2, '0')}:${chat.timestamp.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.grey), // Cor cinza
                        ),
                        onTap: () {
                          _showChatDetails(context, chat); // Abre o modal ao clicar
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}