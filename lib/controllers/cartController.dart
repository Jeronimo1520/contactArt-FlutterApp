import 'package:contact_art/models/Cart.dart';
import 'package:flutter/cupertino.dart';

class CartController extends ChangeNotifier {
  List<Cart> cartItems = [];

  Future<bool> addToCart(String name, String price) {
    cartItems.add(Cart(name, price));
    notifyListeners();
    print(cartItems);
    return Future.value(true);
  }

  Future<bool> deleteTask(int index) {
    cartItems.removeAt(index);
    notifyListeners();
    return Future.value(true);
  }
}
