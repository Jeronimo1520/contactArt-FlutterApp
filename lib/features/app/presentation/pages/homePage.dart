import 'package:contact_art/features/app/presentation/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
   final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
