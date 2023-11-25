import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../models/product_model.dart';
import '../providers/auth_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product product;

  ProductFormScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product.id != 0;
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Agregar Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                'https://www.mountaingoatsoftware.com/uploads/blog/2016-09-06-what-is-a-product.png', // Reemplaza con la URL de la imagen que desees
                height: 200.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Precio'),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL de la Imagen'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Lógica para guardar o actualizar el producto
                  _saveProduct(context);
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct(BuildContext context) async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final imageUrl = _imageUrlController.text;

    // Validar campos vacíos
    if (name.isEmpty || description.isEmpty || imageUrl.isEmpty) {
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
        // Editar producto existente
        final editedProduct = widget.product.copyWith(
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
        );

        await AuthProvider.updateProduct(editedProduct);

        Fluttertoast.showToast(
          msg: 'Producto actualizado con éxito',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Agregar nuevo producto
        await AuthProvider.addProduct(name, description, price, imageUrl);

        Fluttertoast.showToast(
          msg: 'Producto agregado con éxito',
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
        msg: 'Error al guardar el producto: $e',
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
