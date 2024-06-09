import 'package:contact_art/controllers/FavoritesController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class FavoritesScreen extends StatelessWidget {
  final String? userId;

  FavoritesScreen({required this.userId});

  Future<List<FavoriteItem>> getFavoriteItems() async {
    final DocumentSnapshot favoritesSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
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
            userId: userId!,
          ),
        );
      }
    }

    return favoriteItems;
  }

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String title;
  final int price;
  final String itemId;

  FavoriteItem({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.itemId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
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
