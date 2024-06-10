import 'package:contact_art/models/Cart.dart';
import 'package:flutter/cupertino.dart';

class CartController extends ChangeNotifier {
  List<Cart> cartItems = [];

  Future<bool> addToCart(String name, String price, String img, int quantity) {
    cartItems.add(Cart(name, price, img, quantity));
    notifyListeners();
    return Future.value(true);
  }

  Future<bool> deleteTask(int index) {
    cartItems.removeAt(index);
    notifyListeners();
    return Future.value(true);
  }
}
