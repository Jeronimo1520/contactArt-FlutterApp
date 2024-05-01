import 'package:contact_art/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:contact_art/global/common/signUpValidators.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  bool _isSigning = false;

  final FireBaseAuthService _auth = FireBaseAuthService();

  final _formKey = GlobalKey<FormState>();

  String? userType = 'comprador';
  bool termsAccepted = false;
  bool obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: emailController,
                      validator: validateEmail,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      validator: validateName,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      validator: validateLastName,
                      decoration: InputDecoration(
                        labelText: 'Apellido',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      validator: validatePhone,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: idController,
                validator: validateId,
                decoration: InputDecoration(
                  labelText: 'Cédula/NIT',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                validator: validatePassword,
                obscureText: obscureText,
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
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: obscureText,
                controller: confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirma tu contraseña';
                  } else if (value != passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.visibility,
                    ),
                    onPressed: () => togglePasswordVisibility(),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Tipo de usuario'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('Comprador'),
                      leading: Radio<String>(
                        value: 'comprador',
                        groupValue: userType,
                        onChanged: (String? value) {
                          setState(() {
                            userType = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Vendedor'),
                      leading: Radio<String>(
                        value: 'vendedor',
                        groupValue: userType,
                        onChanged: (String? value) {
                          setState(() {
                            userType = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        termsAccepted = value!;
                      });
                    },
                  ),
                  const Text('He leído y acepto los términos y condiciones'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
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
                          : const Text(
                              'Regístrate',
                              style: TextStyle(
                                  fontFamily: 'Poppins', color: Colors.white),
                            ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            termsAccepted) {
                          _signUp();
                          
                        } else {
                          showToast(
                            message: 'Por favor, diligencia todos los campos',
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(
      () {
        _isSigning = true;
      },
    );

    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signUpWithEmailAndPasswod(email, password);
    setState(
      () {
        _isSigning = false;
      },
    );
    if (user != null) {
      showToast(
        message: 'Usuario creado con éxito',
      );
      Navigator.pushNamed(context, '/home');
    } else {
      showToast(
        message: "Hubo un error inesperado",
      );
    }
  }
}
