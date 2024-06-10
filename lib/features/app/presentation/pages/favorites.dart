import 'package:contact_art/controllers/FavoritesController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:contact_art/models/Favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/controllers/cartController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'productDetails.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return MaterialApp(
      home: FavoritesScreen(userId: userId),
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  final String? userId;

  FavoritesScreen({required this.userId});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ValueNotifier<int> _favoritesChangeNotifier = ValueNotifier(0);
  Future<List<FavoriteItem>> getFavoriteItems() async {
    final DocumentSnapshot favoritesSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.userId)
        .get();

    List<String> favoriteIds =
        List<String>.from(favoritesSnapshot['favorites']).toSet().toList();
    List<FavoriteItem> favoriteItems = [];

    for (var id in favoriteIds) {
      final DocumentSnapshot productSnapshot =
          await FirebaseFirestore.instance.collection('products').doc(id).get();
      if (productSnapshot.exists) {
        favoriteItems.add(
          FavoriteItem(
            imageUrl: productSnapshot['img'],
            title: productSnapshot['name'],
            price: int.parse((productSnapshot['price'])),
            itemId: id,
            userId: widget.userId!,
            product: productSnapshot,
            favoritesChangeNotifier: _favoritesChangeNotifier,
          ),
        );
      }
    }

    return favoriteItems;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _favoritesChangeNotifier,
        builder: (context, value, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Mis favoritos'),
              ),
              body: FutureBuilder<List<FavoriteItem>>(
                future: getFavoriteItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  return ListView(
                    children: snapshot.data!,
                  );
                },
              ));
        });
  }
}

class FavoriteItem extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String title;
  final int price;
  final String itemId;
  final DocumentSnapshot product;
  late FavoritesController _favoritesController;
  final ValueNotifier<int> favoritesChangeNotifier;

  FavoriteItem({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.itemId,
    required this.userId,
    required this.product,
    required this.favoritesChangeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    _favoritesController = FavoritesController(userId);
    NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '\$',
      customPattern: '\u00A4#,##0.00',
    );

    return Card(
      child: ListTile(
        leading: Container(
          width: 75.0,
          height: 75.0,
          child: Image.network(imageUrl),
        ),
        title: Text(title),
        subtitle: Text(currencyFormat.format(price)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 24,
              ),
              
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar producto'),
                      content: const Text(
                          '¿Estás seguro de que deseas eliminar este producto de tu lista de favoritos?'),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.purple),
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
                                        backgroundColor: Colors.purple,
                                      ),
                                      child: const Text('Eliminar',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () async {
                                        await _favoritesController
                                            .removeFavorite(product.id);
                                        showToast(
                                            message:
                                                'Producto eliminado de favoritos');
                                        Navigator.of(context).pop();
                                        favoritesChangeNotifier.value++;
                                      })),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );

              },
            ),
            Container(
              width: 114,
              height: 30,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Agregar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
