import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/uploadImage.dart';
import 'package:contact_art/controllers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProductsPage extends StatefulWidget {
  final String? userId;
  const MyProductsPage({Key? key, this.userId}) : super(key: key);
  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  late Stream<QuerySnapshot> _productsStream;
  File? imageToUpload;

  @override
  void initState() {
    super.initState();
    _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis productos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text(doc['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        editProduct(context, doc.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteProduct(doc.id);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto eliminado correctamente'),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el producto: $e'),
        ),
      );
    }
  }

  void editProduct(BuildContext context, String productId) async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    String newProductName = productSnapshot['name'];
    String newProductPrice = productSnapshot['price'];
    String newProductDescription = productSnapshot['description'];
    String newProductCategory = productSnapshot['category'];
    String uploaded = productSnapshot['img'];

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar producto'),
          content: Column(
            children: <Widget>[
              TextFormField(
                initialValue: newProductName,
                decoration: InputDecoration(labelText: 'Nombre del producto'),
                onChanged: (value) {
                  newProductName = value;
                },
              ),
              TextFormField(
                initialValue: newProductPrice,
                decoration: InputDecoration(labelText: 'Precio del producto'),

                onChanged: (value) {
                  newProductPrice = value;
                },
              ),
              TextFormField(
                initialValue: newProductDescription,
                decoration:
                    InputDecoration(labelText: 'Descripción del producto'),

                onChanged: (value) {
                  newProductDescription = value;
                },
              ),
              DropdownButtonFormField<String>(
                items: ['Categoría 1', 'Categoría 2', 'Categoría 3']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  newProductCategory = value!;
                },
                decoration: InputDecoration(labelText: 'Categoría'),
              ),
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
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                updateProduct(productId, newProductName, newProductPrice,
                    newProductDescription, newProductCategory);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateProduct(productId, newProductName, newProductPrice,
      newProductDescription, newProductCategory) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'name': newProductName,
      'price': newProductPrice,
      'category': newProductCategory,
      'description': newProductDescription,
    });
  }
}
