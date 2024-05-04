import 'package:contact_art/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class GoogleSignInWidget extends StatelessWidget {
  final FireBaseAuthService _auth = FireBaseAuthService();

  GoogleSignInWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset('assets/images/google_logo.png', height: 36.0), // Asegúrate de tener este asset en tu carpeta de assets
      label: const Text('Sign in with Google'),
      onPressed: () async {
        User? user = await _auth.signInWithGoogle();
        if (user == null) {
          // El usuario canceló el inicio de sesión o ocurrió un error
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to sign in with Google')),
          );
        } else {
          // El usuario se autenticó correctamente
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed in as ${user.displayName}')),
          );
        }
      },
    );
  }
}