import 'package:contact_art/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:contact_art/features/app/presentation/pages/signUp_page.dart';
import 'package:contact_art/features/app/presentation/widgets/form_container_login_widget.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSigning ? const CircularProgressIndicator(color: Colors.white,) : const Text('Login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      )),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signIn();
                    } else {
                      showToast(message: 'Por favor, diligencia todos los campos');
                    }
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('No te has registrado? '),
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

  void _signIn() async {
    setState(
      () {
        _isSigning = true;
      },
    );
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: 'Usuario creado con éxito');
      Navigator.pushNamed(context, '/home');
    } else {
      showToast(message: "Hubo un error inesperado");

    }
  }
}
