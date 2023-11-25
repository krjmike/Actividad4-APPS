import 'package:actividad_4/screens/user_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await AuthProvider.getUsers();
    setState(() {
      this.users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text('Usuario: ${user.username}\nTeléfono: ${user.phoneNumber}'),
            onTap: () {
              // Mostrar opciones para editar o eliminar al presionar en un elemento
              _showOptionsDialog(user);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abrir pantalla de formulario para agregar nuevo usuario
          _navigateToUserFormScreen(User(id: 0, username: '', password: '', name: '', phoneNumber: ''));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showOptionsDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Opciones para ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Editar'),
              onTap: () {
                // Abrir pantalla de formulario para editar usuario
                Navigator.of(context).pop();
                _navigateToUserFormScreen(user);
              },
            ),
            ListTile(
              title: Text('Eliminar'),
              onTap: () {
                // Implementa la lógica para eliminar el usuario
                _deleteUser(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToUserFormScreen(User user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserFormScreen(user: user),
      ),
    );

    // Recargar la lista solo si se realizó alguna modificación en el formulario
    if (result != null && result) {
      await _loadUsers();
    }
  }

  void _deleteUser(User user) async {
    await AuthProvider.deleteUser(user.id);
    await _loadUsers();
    Fluttertoast.showToast(
      msg: 'Usuario eliminado con éxito',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}