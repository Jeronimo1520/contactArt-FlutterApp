import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/ProductController.dart';
import 'package:contact_art/features/app/presentation/widgets/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'productDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final String? userId;
  const HomePage({Key? key, this.userId}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(keepPage: false);
  final ProductController productController = ProductController();
  late String _searchTerm = '';
  late String userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchTerm = value;
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _searchTerm.isEmpty
            ? productController.getProductsStream()
            : productController.searchProductsStream(_searchTerm),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return Center(
            child: Container(
              width: 380,
              height: 540,
              child: PageView.builder(
                controller: _controller,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot product = snapshot.data!.docs[index];

                  // Asegúrate de que el precio se maneja como un número
                  double price = 0.0;
                  if (product['price'] is int) {
                    price = product['price'].toDouble();
                  } else if (product['price'] is double) {
                    price = product['price'];
                  } else if (product['price'] is String) {
                    price = double.tryParse(product['price']) ?? 0.0;
                  }

                  // Formatea el precio
                  final formattedPrice = NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(price);

                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              product: product,
                              userId: widget.userId!,
                            ),
                          ),
                        );
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 1),
                          curve: Curves.easeIn,
                        );
                      }
                      return false;
                    },
                    child: Container(
                      height: 320,
                      width: 300,
                      child: Card(
                        elevation: 5,
                        borderOnForeground: true,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 300,
                                  width: 380,
                                  child: Image.network(
                                    product['img'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                formattedPrice,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.red.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          )),
                                      child: Icon(Icons.arrow_back, color: Colors.white),
                                      onPressed: () {
                                        _controller.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.green.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          )),
                                      child: Icon(Icons.remove_red_eye, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                product: product, userId: userId),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        context: context,
      ),
    );
  }
}




