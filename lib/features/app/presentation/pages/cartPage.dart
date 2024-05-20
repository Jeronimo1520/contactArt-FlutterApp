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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Eliminar producto'),
                          content: const Text(
                              '¿Estás seguro de que deseas eliminar este producto del carrito?'),
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
                                          backgroundColor: Colors.purple),
                                      child: Text('Eliminar',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        setState(() {
                                          items.removeAt(index);
                                        });
                                        showToast(
                                            message:
                                                "Producto eliminado del carrito");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      });
                }),
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
