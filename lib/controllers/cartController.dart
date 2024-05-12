import 'package:contact_art/models/Cart.dart';
import 'package:flutter/cupertino.dart';

class CartController extends ChangeNotifier{
  List<Cart> cartItems = [];

  void addToCart(String name, String price) {
    cartItems.add(Cart(name, price));
    notifyListeners();
    print(cartItems);
  }

  void deleteTask(int index) {
    cartItems.removeAt(index);
    notifyListeners();
  }
}
