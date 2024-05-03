import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final BuildContext context;
  final String? userId;

  static const List<String> _pages = <String>[
    '/perfil',
    '/informacion',
    '/home',
    '/mensajes',
    '/carrito',
  ];

  BottomNavBar({required this.selectedIndex, required this.context, this.userId});

  void _onItemTapped(int index) {
    Navigator.pushNamed(context, _pages[index], arguments: {'userId': userId});
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Información',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Mi Carrito',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: const Color.fromRGBO(75, 7, 87, 1),
      onTap: _onItemTapped,
    );
  }
}


                
