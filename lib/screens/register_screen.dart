import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre Completo'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Número de Teléfono'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _register();
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  void _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty && name.isNotEmpty && phoneNumber.isNotEmpty) {
      await AuthProvider.registerUser(username, password, name, phoneNumber);

      Fluttertoast.showToast(
        msg: "Registro exitoso",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.pop(context); // Volver a la pantalla anterior (puede ser la pantalla de inicio de sesión).
    } else {
      // Mostrar un mensaje de error si los campos están vacíos.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Campos Vacíos'),
          content: Text('Por favor, complete todos los campos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
