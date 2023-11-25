

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';
import 'database_helper.dart';


class AuthProvider {
  static DatabaseHelper _databaseHelper = DatabaseHelper();

  static Future<void> registerUser(String username, String password, String name, String phoneNumber) async {
    final user = User(username: username, password: password, name: name, phoneNumber: phoneNumber);
    await _databaseHelper.insertUser(user);
  }

  static Future<bool> loginUser(String username, String password) async {
    final users = await _databaseHelper.getUsers();

    if (users.any((user) => user.username == username && user.password == password))
    {
      final user =users.firstWhere((user) => user.username == username && user.password == password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', user.name);
      return true;
    }
    else{
      return false;
    }
  }



  static Future<void> addProduct(String name, String description, double price, String imageUrl) async {
    final product = Product(name: name, description: description, price: price, imageUrl: imageUrl);
    await _databaseHelper.insertProduct(product);
  }

  static Future<List<User>> getUsers() async {
    return _databaseHelper.getUsers();
  }

  static Future<List<Product>> getProducts() async {
    return _databaseHelper.getProducts();
  }

  static Future<void> updateUser(User user) async {
    await _databaseHelper.updateUser(user);
  }

  static Future<void> updateProduct(Product product) async {
    await _databaseHelper.updateProduct(product);
  }

  static Future<void> deleteUser(int? userId) async {
    await _databaseHelper.deleteUser(userId);
  }

  static Future<void> deleteProduct(int? productId) async {
    await _databaseHelper.deleteProduct(productId);
  }
}