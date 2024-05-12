import 'package:contact_art/features/app/presentation/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Carrito'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index].title),
            subtitle: Text(cartItems[index].price.toString()),
            trailing: IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 4,
        context: context,
      ),
    );
  }
}

class CartModel {
  final String title;
  final String price;

  CartModel({required this.title, required this.price});
}
