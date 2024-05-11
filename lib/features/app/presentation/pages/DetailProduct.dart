
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailPage extends StatelessWidget {
  final DocumentSnapshot product;

  DetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${product['name']}',)
          
        ),
        body: Center(
          child: Column(
            children: [
               Container( 
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: Image.network(
                  product['img'],
                  fit: BoxFit.cover,
                  height: 330,
                ),
                ),
                
              Padding(
                padding: EdgeInsets.only(left: 25, top: 32),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Precio: \$${product['price']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Container(
                  height: 125, 
                  width: 380, 
                  padding: EdgeInsets.all(10), 
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple.shade700), 
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  child: SingleChildScrollView( 
                    child: Text(
                      ' ${product['description']}', 
                        style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.zero,
          child: BottomAppBar(
              color: Colors.white,
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children:[ Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Container( 
                      height: 32,
                      width: 130,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.purple), // Hacer el botón morado
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>( // Hacer los bordes cuadrados
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        onPressed: () {
                        // Agregar aquí la lógica para agregar al carrito
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centrar los elementos en la fila
                          children: [
                            Icon(Icons.add_shopping_cart, color: Colors.white), // Agregar el icono
                            SizedBox(width: 6), // Agregar un espacio entre el icono y el texto
                            Text('Agregar', style: TextStyle(color: Colors.white, fontSize:13)),
                          ],
                        ),
                        
                      ),
                    ),
                  ),
                  SizedBox(width: 28),
                  GestureDetector(
                    onTap: () {
                    // Agregar aquí la lógica para agregar a favoritos
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border, size: 25),
                        Text(
                          'Favoritos',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                ),
                  ],
                ),
                ]
              ),
              
            ),
        ),
      
      
    );
  }
}