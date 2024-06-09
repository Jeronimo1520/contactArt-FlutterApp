import 'dart:io';
import 'package:contact_art/controllers/productController.dart';
import 'package:contact_art/controllers/uploadImage.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/global/common/addProductsValidators.dart';
import 'package:contact_art/models/Product.dart' as AppProduct;
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:contact_art/controllers/userProvider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController nameController = TextEditingController();
  MaskedTextController priceController = MaskedTextController(mask: '000,000,000.00'); // Usa MaskedTextController
  TextEditingController descriptionController = TextEditingController();

  String? categoryType = '';

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
              validator: validateName,
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre del producto'),
            ),
            SizedBox(height: 16),
            TextFormField(
              validator: validatePrice,
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Precio del producto'),
            ),
            SizedBox(height: 16),
            TextFormField(
              validator: validateDescription,
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: ['Cuadros', 'Manualidades', 'Esculturas']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                categoryType = value;
              },
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
                      bool result = await _publishProduct();
                      if (result) {
                        showToast(message: "Producto publicado correctamente");
                      } else {
                        showToast(message: "Error al publicar el producto");
                      }
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

  Future<bool> _publishProduct() async {
    final uploaded = await uploadImage(imageToUpload!);
    // ignore: use_build_context_synchronously
    String userId = Provider.of<UserProvider>(context, listen: false).userId;
    AppProduct.Product product = AppProduct.Product(
      price: priceController.text.replaceAll(',', ''), 
      name: nameController.text,
      img: uploaded.toString(),
      description: descriptionController.text,
      category: categoryType!,
      userId: userId,
    );

    final result = await _productController.createProduct(product);

    if (result.isNotEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto publicado correctamente'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/home');
      return true;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al publicar el producto'),
        ),
      );
    }
    return false;
  }
}


