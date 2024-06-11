import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/uploadImage.dart';
import 'package:contact_art/controllers/userProvider.dart';
import 'package:contact_art/global/common/toast.dart';
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
        .where('userId', isEqualTo: getUser())
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
                leading: Image.network(doc['img'],
                    width: 50, height: 50, fit: BoxFit.cover),
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
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar producto'),
                                content: const Text(
                                    '¿Estás seguro de que deseas eliminar este producto de tu lista de productos publicados?'),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            child: const Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                  color: Colors.purple),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.purple),
                                              child: Text('Eliminar',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                bool result =
                                                    await deleteProduct(doc.id);
                                                if (result) {
                                                  showToast(
                                                      message:
                                                          "Producto eliminado");
                                                  Navigator.of(context).pop();
                                                }
                                                ;
                                              }),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
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

  String getUser() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String userId = userProvider.userId;
    return userId;
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      return true;
    } catch (e) {
      return false;
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
                items: ['Cuadros', 'Manualidades', 'Esculturas']
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
                bool result = await updateProduct(
                    productId,
                    newProductName,
                    newProductPrice,
                    newProductDescription,
                    newProductCategory,
                    imageToUpload);
                if (result) {
                  Navigator.of(context).pop();
                  showToast(message: 'Producto actualizado correctamente');
                } else {
                  showToast(message: 'Error al actualizar el producto');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> updateProduct(productId, newProductName, newProductPrice,
      newProductDescription, newProductCategory, imageToUpload) async {
    final uploaded = await uploadImage(imageToUpload!);
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'name': newProductName,
      'price': newProductPrice,
      'category': newProductCategory,
      'description': newProductDescription,
      'img': uploaded.toString(),
    });
    // ignore: use_build_context_synchronously

    return true;
  }
}
