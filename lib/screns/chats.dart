import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helper_coder/main.dart'; // Importe o main.dart para acessar MyAppState

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          body: Container(
            color: Colors.white,
            child: appState.chats.isEmpty
                ? const Center(child: Text('Nenhum chat salvo ainda.'))
                : ListView.builder(
                    itemCount: appState.chats.length,
                    itemBuilder: (context, index) {
                      final chat = appState.chats[index];
                      return ListTile(
                        title: Text(chat.question),
                        subtitle: Text(chat.response.length > 50
                            ? '${chat.response.substring(0, 50)}...'
                            : chat.response),
                        trailing: Text(
                          '${chat.timestamp.hour}:${chat.timestamp.minute}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          // Navegação para detalhes do chat, se desejar
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