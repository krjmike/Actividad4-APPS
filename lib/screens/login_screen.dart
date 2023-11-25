import 'package:actividad_4/screens/register_screen.dart';
import 'package:actividad_4/screens/user_form_screen.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Reemplaza con la ruta de tu imagen
              height: 200.0, // Ajusta la altura según tus necesidades
            ),
            SizedBox(height: 16.0),
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
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserFormScreen(user: User(id: 0, username: '', password: '', name: '', phoneNumber: ''))), // Navegar a la pantalla de registro
                );
              },
              child: Text('Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      bool loginSuccess = await AuthProvider.loginUser(username, password);

      if (loginSuccess) {
        // Navegar a la pantalla principal o a la siguiente pantalla después del inicio de sesión.
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Mostrar un mensaje de error al usuario.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error de Inicio de Sesión'),
            content: Text('Nombre de usuario o contraseña incorrectos.'),
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
