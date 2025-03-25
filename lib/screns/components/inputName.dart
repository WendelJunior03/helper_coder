// input para usuario digitar o nome
import 'package:flutter/material.dart';

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
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final name = _nameController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hello, $name!'),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}


