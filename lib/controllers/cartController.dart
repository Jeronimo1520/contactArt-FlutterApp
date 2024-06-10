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
    return FirebaseFirestore.instance.collection(collection).snapshots();
  }

  Future<bool> deleteTask(int index) {
    cartItems.removeAt(index);
    notifyListeners();
    return Future.value(true);
  }
}
