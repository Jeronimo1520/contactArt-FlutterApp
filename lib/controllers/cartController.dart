// ignore: file_names
import 'package:contact_art/models/Cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartController extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String collection = "cart";
  List<Cart> cartItems = [];

  Future<String> addToCart(Cart cart) async {
    try {
      DocumentReference docRef =
          await db.collection(collection).add(cart.toJson());
      return docRef.id;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<Cart> getCart(String cartId) async {
    try {
      DocumentSnapshot docSnapshot =
          await db.collection(collection).doc(cartId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        return Cart.fromJson(data);
      } else {
        throw Exception('Carrito no encontrado');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Stream<QuerySnapshot> getCartStream() {
    return db.collection(collection).snapshots();
  }

  Future<void> updateQuantity(String cartId, int quantity) async {
    try {
      await db
          .collection(collection)
          .doc(cartId)
          .update({'quantity': quantity});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteItem(String cartId) async {
    try {
      await db.collection(collection).doc(cartId).delete();
    } catch (e) {
      print(e);
    }
  }
}
