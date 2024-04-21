import 'package:contact_art/features/user_auth/presentation/pages/signUp_page.dart';
import 'package:contact_art/features/user_auth/presentation/widgets/form_container_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                child: const Text('Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    )),
                onPressed: () {
                  if (_emailController.text.isNotEmpty ||
                      _passwordController.text.isNotEmpty) {
                    print('Login exitoso');
                  } else {
                    print('Por favor, diligencia todos los campos');
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
    );
  }
}
