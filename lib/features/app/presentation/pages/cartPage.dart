import 'package:contact_art/features/app/presentation/widgets/bottomNavBar.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/controllers/cartController.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'PaymentPage.dart'; 

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

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '\$',
      customPattern: '\u00A4#,##0.00',
    );

    double total = items.fold(0.0, (sum, item) => sum + (item.quantity * double.tryParse(item.price.toString())!));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Carrito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final double price = double.tryParse(item.price.toString()) ?? 0.0;
                  final String itemName = item.name.replaceAll("'", "");

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        item.img,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(itemName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currencyFormat.format(price)),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    } else {
                                      items.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    item.quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar producto'),
                                content: const Text('¿Estás seguro de que deseas eliminar este producto del carrito?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      setState(() {
                                        items.removeAt(index);
                                      });
                                      showToast(message: "Producto eliminado del carrito");
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: Theme.of(context).textTheme.headline6),
                  Text(currencyFormat.format(total), style: Theme.of(context).textTheme.headline6),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(total: total),
                    ),
                  );
                },
                child: const Text('Proceder a la compra'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 4,
        context: context,
      ),
    );
  }
}
