// input para usuario digitar o nome
import 'package:flutter/material.dart';
import 'package:helper_coder/screns/home_page.dart';

class InputName extends StatefulWidget {
  const InputName({Key? key}) : super(key: key);

  @override
  _InputNameState createState() => _InputNameState();
}

class _InputNameState extends State<InputName> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextFormField(
            style: const TextStyle(
              color: Color.fromARGB(255, 158, 158, 158),
            ),
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Digite seu nome',
              border: OutlineInputBorder(),
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 27, 27, 27),
              prefixIconColor: Color.fromARGB(255, 136, 136, 136),
              prefixIcon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 136, 136, 136),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite seu nome';
              }
              return null;
            },
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 27, 27, 27),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final name = _nameController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Bem Vindo(a), $name!',
                      style: TextStyle(
                          color: const Color.fromARGB(192, 255, 255, 255)),
                    ),
                    backgroundColor: const Color.fromARGB(255, 21, 21, 21),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              }
            },
            child: const Text('Entrar',
                style: TextStyle(
                  color: Color.fromARGB(255, 180, 180, 180),
                  fontSize: 20,
                )),
          ),
        ],
      ),
    );
  }
}
