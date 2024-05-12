import 'package:contact_art/controllers/productController.dart';
import 'package:contact_art/features/app/presentation/widgets/BottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DetailProduct.dart';

class HomePage extends StatefulWidget {
  final String? userId;

  const HomePage({Key? key, this.userId}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(keepPage: false);
  final ProductController productController = ProductController();
  String? userId;

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
        title: Text('ContactArt'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productController.getProductsStream(),
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
              
                  return Dismissible(
                    key: UniqueKey(), 
                    direction: DismissDirection.horizontal, 
                    confirmDismiss: (direction)async {
                      if (direction == DismissDirection.startToEnd) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(product: product, userId: widget.userId,),
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
                                    fit:BoxFit.cover,
                                  ),
                                  ),
                                ),
                                
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ) ,
                              ),
                              Text(
                                '\$${product['price']}',
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
                                        )
                                      ),
                                      child: Icon(Icons.arrow_back, color: Colors.white),
                                      onPressed: () {
                                        _controller.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width:100),
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.green.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                        )
                                      ),
                                      child: Icon(Icons.remove_red_eye, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(product: product,userId: userId),
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


