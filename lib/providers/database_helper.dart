import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';


class DatabaseHelper {
  static const String dbName = 'my_database.db';
  static const String userTable = 'users';
  static const String productTable = 'products';

  Future<Database> openDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $userTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT,
          name TEXT,
          phoneNumber TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE $productTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          price REAL,
          imageUrl TEXT
        )
      ''');
    });
  }

  Future<int> insertUser(User user) async {
    final db = await openDb();
    return db.insert(userTable, user.toMap());
  }

  Future<int> insertProduct(Product product) async {
    final db = await openDb();
    return db.insert(productTable, product.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(userTable);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
      );
    });
  }

  Future<List<Product>> getProducts() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(productTable);
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        price: maps[i]['price'],
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }

  Future<int> updateUser(User user) async {
    final db = await openDb();
    return db.update(
      userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateProduct(Product product) async {
    final db = await openDb();
    return db.update(
      productTable,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteUser(int? userId) async {
    final db = await openDb();
    return db.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteProduct(int? productId) async {
    final db = await openDb();
    return db.delete(
      productTable,
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

}