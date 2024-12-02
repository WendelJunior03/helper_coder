import 'package:flutter/material.dart';
import 'package:helper_coder/screns/tela_informacoes.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'HELPER CODER',
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
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                blurRadius: 3,
                spreadRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Telainformacoe(),
      ),
    );
  }
}