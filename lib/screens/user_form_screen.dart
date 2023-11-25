import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';


class UserFormScreen extends StatefulWidget {
  final User user;

  UserFormScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  late bool _isEditing; // campo para determinar si estamos editando

  @override
  void initState() {
    super.initState();

    _isEditing = widget.user.id != 0; // Determinar si estamos editando
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController(text: widget.user.password);
    _nameController = TextEditingController(text: widget.user.name);
    _phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Usuario' : 'Agregar Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEpWWQrAJpIR6Xy7FhzhCT00vzSmT7xw9S2Q&usqp=CAU', // Reemplaza con la URL de la imagen que desees
                height: 200.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Número de Teléfono'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Lógica para guardar o actualizar el usuario
                  _saveUser(context);
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUser(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final phoneNumber = _phoneNumberController.text;

    // Validar campos vacíos
    if (username.isEmpty || password.isEmpty || name.isEmpty || phoneNumber.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Por favor, completa todos los campos',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      if (_isEditing) {
        // Editar usuario existente
        final editedUser = widget.user.copyWith(
          username: username,
          password: password,
          name: name,
          phoneNumber: phoneNumber,
        );

        await AuthProvider.updateUser(editedUser);

        Fluttertoast.showToast(
          msg: 'Usuario actualizado con éxito',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Agregar nuevo usuario
        await AuthProvider.registerUser(username, password, name, phoneNumber);

        Fluttertoast.showToast(
          msg: 'Usuario agregado con éxito',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      Navigator.pop(context, true); // Retornar true para indicar éxito al formulario anterior
    } catch (e) {
      // Manejar la excepción y mostrar un toast con el mensaje de error
      Fluttertoast.showToast(
        msg: 'Error al guardar el usuario: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
