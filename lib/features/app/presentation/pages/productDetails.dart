import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/cartController.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:contact_art/controllers/FavoritesController.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot product;
  final String? userId;

  DetailPage({required this.product, required this.userId});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  FavoritesController? _favoritesController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _favoritesController = FavoritesController(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '${widget.product['name']}',
      )),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
              ),
              child: Image.network(
                widget.product['img'],
                fit: BoxFit.cover,
                height: 330,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, top: 32),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Precio: \$${widget.product['price']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Container(
                height: 125,
                width: 380,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple.shade700),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    ' ${widget.product['description']}',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: SizedBox(
                        height: 32,
                        width: 130,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.purple),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            bool result = await cartController.addToCart(
                                "'${widget.product['name']}'",
                                '${widget.product['price']}');
                            if (result) {
                              showToast(
                                  message: "Producto agregado al carrito");
                            } else {
                              showToast(
                                  message:
                                      "Error al agregar el producto al carrito");
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_shopping_cart,
                                  color: Colors.white),
                              SizedBox(width: 6),
                              Text('Agregar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                    Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          if (isFavorite) {
                            await _favoritesController
                                ?.removeFavorite(widget.product.id);
                            showToast(
                                message: 'Producto eliminado de favoritos');
                          } else {
                            await _favoritesController
                                ?.addFavorite(widget.product.id);
                            showToast(message: 'Producto agregado a favoritos');
                          }
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Colors.purple.shade700
                                    : Colors.black,
                                size: 25),
                            Text(
                              'Favoritos',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
