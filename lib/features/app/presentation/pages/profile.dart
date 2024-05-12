import 'package:contact_art/controllers/UserController.dart';
import 'package:contact_art/controllers/UserProvider.dart';
import 'package:contact_art/features/app/presentation/pages/addProduct.dart';
import 'package:contact_art/features/app/presentation/pages/editProfile.dart';
import 'package:contact_art/features/app/presentation/widgets/bottomNavBar.dart';
import 'package:contact_art/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:contact_art/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  UserController userController = UserController();
  String? _userId;
  FireBaseAuthService _auth = FireBaseAuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Perfil de Usuario'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserProvider>(
            builder: (context, value, child) {
              _user = value.user;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/logoWhiteBackground.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user != null ? _user!.userName : 'Cargando...',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(user: _user, userId: _userId),
                            ),
                          );
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
                    '${_user != null ? _user!.description : 'Cargando...'}',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProductPage()),
                      );
                    },
                    child: const Text('Añadir producto'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await _auth.signOut();
                          Navigator.pushNamed(context, '/login');
                        } catch (e) {
                          // Muestra un mensaje de error si algo sale mal
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al cerrar sesión: $e'),
                            ),
                          );
                          print(e.toString());
                        }
                      },
                      child: const Text('Cerrar sesión')),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: 0,
          context: context,
        ),
      );
  }

  void _loadUserData() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    User user = userProvider.user;
    String userId = userProvider.userId;

    _user = user;
    _userId = userId;

    print("user profile: ${_user.toString()}");
    print("userId profile: $_userId");

    setState(() {});
  }
}
