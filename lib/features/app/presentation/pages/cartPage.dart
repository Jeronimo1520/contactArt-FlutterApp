import 'package:contact_art/features/app/presentation/widgets/bottomNavBar.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/controllers/cartController.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final items = cartController.cartItems;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Carrito'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text(items[index].price.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
                showToast(message: "Producto eliminado del carrito");
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
