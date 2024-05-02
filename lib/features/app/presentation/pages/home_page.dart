import 'package:contact_art/features/app/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
   final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    // Aquí puedes incluir las páginas que desees para cada ítem del menú
    Text('Perfil'),
    Text('Información'),
    Text('Favoritos'),
    Text('Carrito'),
    Text('Carrito'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushNamed(context,
            '/editProfile'); // Navega a la página EditProfilePage cuando se selecciona el ícono "person"
      }
      if (_selectedIndex == 1) {
        Navigator.pushNamed(context,
            '/addProduct'); // Navega a la página EditProfilePage cuando se selecciona el ícono "person"
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('ContactArt'),
      ),
      body: Center(
        child: Text("Este es el inicio"),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        context: context,
      ),
    );
  }
}
