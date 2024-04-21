import 'package:flutter/material.dart';

class FormContainerLoginWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function togglePasswordVisibility;
  final bool obscureText;

  

  FormContainerLoginWidget({
    required this.emailController,
    required this.passwordController,
    required this.togglePasswordVisibility,
     required this.obscureText,
  });

   String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu correo';
    } else if (!value.contains('@')) {
      return 'Por favor, ingresa un correo válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu contraseña';
    } else if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator : validateEmail,
            style: const TextStyle(fontFamily: 'Poppins'),
            decoration: InputDecoration(
              labelText: 'Correo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(fontFamily: 'Poppins'),
            obscureText: obscureText,
            validator : validatePassword,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.visibility,
                ),
                onPressed: () => togglePasswordVisibility(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}