import 'package:contact_art/controllers/UserController.dart';
import 'package:contact_art/features/app/presentation/widgets/bottomNavBar.dart';
import 'package:contact_art/models/User.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  UserController userController = UserController();
  String? userId;

 
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userId = args['userId'];
    _loadUserData(userId!);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Perfil',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil de Usuario'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/logoWhiteBackground.png'),
              ),
              const SizedBox(height: 16),
              Text(
                user != null ? user!.userName : 'Cargando...',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, '/editProfile');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      // Acción al presionar el botón de configuración
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      // Acción al presionar el botón de favoritos
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                '${user != null ? user!.description : 'Cargando...'}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.add),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addProduct');
                  // Acción al presionar el botón "Añadir producto"
                },
                child: const Text('Añadir producto'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: 0,
          context: context,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  void _loadUserData(String userId) async {
    user = await userController.getUser(userId);
    setState(() {});
  }
}
