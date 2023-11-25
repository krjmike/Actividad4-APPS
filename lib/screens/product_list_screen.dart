import 'package:actividad_4/screens/product_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/product_model.dart';
import '../providers/auth_provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await AuthProvider.getProducts();
    setState(() {
      this.products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(
              product.imageUrl,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text(
              'Descripción: ${product.description}\nPrecio: \$${product.price.toString()}',
            ),
            onTap: () {
              // Mostrar opciones para editar o eliminar al presionar en un elemento
              _showOptionsDialog(product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abrir pantalla de formulario para agregar nuevo producto
          _navigateToProductFormScreen(Product(id: 0, name: '', description: '', price: 0.0, imageUrl: ''));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showOptionsDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Opciones para ${product.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Editar'),
              onTap: () {
                // Abrir pantalla de formulario para editar producto
                Navigator.of(context).pop();
                _navigateToProductFormScreen(product);
              },
            ),
            ListTile(
              title: Text('Eliminar'),
              onTap: () {
                // Implementa la lógica para eliminar el producto
                _deleteProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductFormScreen(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );

    // Recargar la lista solo si se realizó alguna modificación en el formulario
    if (result != null && result) {
      await _loadProducts();
    }
  }

  void _deleteProduct(Product product) async {
    await AuthProvider.deleteProduct(product.id);
    await _loadProducts();
    // Muestra un Toast para informar que el producto se eliminó con éxito
    Fluttertoast.showToast(
      msg: 'Producto eliminado con éxito',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}