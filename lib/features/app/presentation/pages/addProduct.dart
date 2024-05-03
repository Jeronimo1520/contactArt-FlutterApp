import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/productController.dart';
import 'package:contact_art/controllers/uploadImage.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/models/Product.dart' as AppProduct;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  String? categoryType = 'Categoría 1';

  File? imageToUpload;

  final ProductController _productController = ProductController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre del producto'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Precio del producto'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: ['Categoría 1', 'Categoría 2', 'Categoría 3']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {},
              decoration: InputDecoration(labelText: 'Categoría'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final image = await getImage();
                      setState(() {
                        imageToUpload = File(image!.path);
                      });
                      if (imageToUpload == null) {
                        return;
                      }
                    },
                    child: Text('Seleccionar imagen'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _publishProduct();
                    },
                    child: Text('Publicar producto'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _publishProduct() async {

    final uploaded = await uploadImage(imageToUpload!);

    AppProduct.Product product = AppProduct.Product(
      price: priceController.text,
      name: nameController.text,
      img: uploaded.toString(),
      description: descriptionController.text,
      category: 'Categoría 1',
    );

    final result = await _productController.createProduct(product);

    if (result.isNotEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto publicado correctamente'),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al publicar el producto'),
        ),
      );
    }
  }
}
