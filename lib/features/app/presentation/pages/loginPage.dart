import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/controllers/userController.dart';
import 'package:contact_art/controllers/userProvider.dart';
import 'package:contact_art/features/app/presentation/pages/homePage.dart';
import 'package:contact_art/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:contact_art/features/app/presentation/pages/signUpPage.dart';
import 'package:contact_art/features/app/presentation/widgets/formContainerLoginWidget.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contact_art/models/User.dart' as AppUser;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isSigning = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FireBaseAuthService _auth = FireBaseAuthService();
  final UserController _userController = UserController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            children: <Widget>[
              Image.asset('assets/images/logoNoBackground.png'),
              const SizedBox(height: 30),
              FormContainerLoginWidget(
                emailController: _emailController,
                passwordController: _passwordController,
                togglePasswordVisibility: _togglePasswordVisibility,
                obscureText: _obscureText,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isSigning
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Ingresar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            )),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signIn();
                      } else {
                        showToast(
                            message: 'Por favor, diligencia todos los campos');
                      }
                    }),
              ),
              const SizedBox(height: 5),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                // Icono de Google
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              Text(' Entrar con Google',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          onPressed: () {
                            _signInGoogle();
                          }))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('¿No te has registrado? '),
                  TextButton(
                    child: const Text(
                      'Regístrate aquí',
                      style: TextStyle(
                        color: Colors.purple,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () {
                      // Navega a la página de registro
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInGoogle() async {
    User? user = await FireBaseAuthService.signInWithGoogle();
    String? userId = user!.uid;
    print('Usuario logueado con Google ${user.uid}');
    bool exists = await _userController.userExists(user.email!);
    if (!exists) {
      AppUser.User userModel = AppUser.User(
          id: userId,
          email: user.email?.split(' ')[0] ?? '',
          idNIT: '',
          name: user.displayName?.split(' ')[0] ?? '',
          lastName: user.displayName?.split(' ')[1] ?? '',
          phone: user.phoneNumber ?? '',
          userName: user.displayName?.split(' ')[0] ?? '',
          photoUrl: user.photoURL,
          termsAccepted: true,
          type: 'comprador');
      await _userController.createUser(userModel);
      // ignore: avoid_print
      print('Usuario creado con ID: $userId');
      Navigator.pushNamed(context, '/home');
    } else {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userDoc = await users.doc(user.uid).get();
      String userId = userDoc.id;
      AppUser.User userModel =
          AppUser.User.fromJson(userDoc.data() as Map<String, dynamic>);

      print('Usuario ya existe con ID: $userId');
      print('Usuario ya existe con ID: ${userModel.id}');

      if (userModel.id == null) {
        userModel.id = userId;
        await _userController.updateUserData(
            userId, userModel.userName, '', '', '');
      }
      Provider.of<UserProvider>(context, listen: false).setUser(userModel);
      Provider.of<UserProvider>(context, listen: false).setUserId(userId);
    }
    Navigator.pushNamed(context, '/home');
  }

  void _signIn() async {
    setState(
      () {
        _isSigning = true;
      },
    );
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        showToast(message: 'Ingreso exitoso');

        final CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        DocumentSnapshot userDoc = await users.doc(user.uid).get();
        String firestoreUserId = userDoc.id;

        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false).setUser(
            AppUser.User.fromJson(userDoc.data() as Map<String, dynamic>));

        Provider.of<UserProvider>(context, listen: false)
            .setUserId(firestoreUserId);

        print("USUARIO ID FIRESTORE: ${firestoreUserId}");

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const HomePage(), // Esto Pasa el ID del usuario a HomePage
          ),
        );
      } else {
        return null;
      }
    } catch (e) {
      showToast(message: 'Error al iniciar sesión');
    }
    setState(() {
      _isSigning = false;
    });
  }
}
