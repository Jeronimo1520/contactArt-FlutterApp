import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/UserController.dart';
import 'package:contact_art/controllers/cartController.dart';
import 'package:contact_art/features/app/presentation/pages/chatPage.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:contact_art/models/User.dart';
import 'package:contact_art/models/Cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact_art/controllers/FavoritesController.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot product;
  final String userId;

  DetailPage({required this.product, required this.userId});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  FavoritesController? _favoritesController;
  bool isFavorite = false;
  UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _favoritesController = FavoritesController(widget.userId);
    _checkFavoriteStatus();
  }

  _checkFavoriteStatus() async {
    bool favoriteStatus =
        await _favoritesController!.isFavorite(widget.product.id);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    double price = 0.0;
    if (widget.product['price'] is int) {
      price = (widget.product['price'] as int).toDouble();
    } else if (widget.product['price'] is double) {
      price = widget.product['price'];
    } else if (widget.product['price'] is String) {
      price = double.tryParse(widget.product['price']) ?? 0.0;
    }

    // Formatea el precio
    final formattedPrice =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(price);

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
                  'Precio: $formattedPrice',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Chatea con el vendedor'),
                IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () async {
                      String receiverUserId = widget.product['userId'];
                      User receiverUser =
                          await _userController.getUser(receiverUserId);
                      String receiverUserName = receiverUser.userName;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverUserId: receiverUserId,
                            receiverUserName: receiverUserName,
                            currentUserId: widget.userId,
                          ),
                        ),
                      );
                    })
              ],
            ),
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
                            bool result = await addToCart();

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
                          setState(() {
                            isLoading = true;
                          });
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
                          bool favoriteStatus = await _favoritesController!
                              .isFavorite(widget.product.id);
                          setState(() {
                            isFavorite = favoriteStatus;
                            isLoading = false;
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

  Future<bool> addToCart() async {
    String userId = widget.userId;
    final cartController = Provider.of<CartController>(context, listen: false);
    Cart cart = Cart(
      name: widget.product['name'],
      price: widget.product['price'],
      img: widget.product['img'],
      quantity: 1,
      userId: userId,
    );
    String result = await cartController.addToCart(cart);
    return result != "";
  }
}
