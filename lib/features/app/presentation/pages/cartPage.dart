import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/userProvider.dart';
import 'package:contact_art/features/app/presentation/widgets/bottomNavBar.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'PaymentPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Stream<QuerySnapshot> cartStream;

  @override
  void initState() {
    super.initState();
    cartStream = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: getUser())
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '\$',
      customPattern: '\u00A4#,##0.00',
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Carrito'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los productos'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay productos en el carrito'));
          }

          final items = snapshot.data!.docs.map((doc) {
            return CartItem(
              img: doc['img'],
              name: doc['name'],
              price: double.tryParse(doc['price'].toString()) ?? 0.0,
              quantity: doc['quantity'],
            );
          }).toList();

          final double total = items.fold(
            0.0,
            (sum, item) => sum + (item.quantity * item.price),
          );

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Image.network(
                            item.img,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currencyFormat.format(item.price)),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  item.quantity > 1
                                      ? IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (item.quantity > 1) {
                                                item.quantity--;
                                              }
                                            });
                                          },
                                        )
                                      : const SizedBox(
                                          width: 48,
                                          height: 48,
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
                                    content: const Text(
                                        '¿Estás seguro de que deseas eliminar este producto del carrito?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Eliminar',
                                            style: TextStyle(color: Colors.red)),
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
                      Text('Total:', style: Theme.of(context).textTheme.titleLarge),
                      Text(currencyFormat.format(total),
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: items.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(total: total),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Proceder a la compra'),
                  ),
                ),
              ],
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

  String getUser() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String userId = userProvider.userId;
    return userId;
  }
}

class CartItem {
  final String img;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.img,
    required this.name,
    required this.price,
    required this.quantity,
  });
}
