import 'package:contact_art/controllers/userController.dart';
import 'package:contact_art/features/app/presentation/pages/homePage.dart';
import 'package:contact_art/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:contact_art/global/common/signUpValidators.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:contact_art/models/User.dart' as AppUser;
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

  final UserController _userController = UserController();

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
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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
                      keyboardType: TextInputType.name,
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
                      keyboardType: TextInputType.name,
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
                      keyboardType: TextInputType.phone,
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
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.visiblePassword,
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
                        } else if (!termsAccepted){
                          showToast(
                            message: 'Por favor, acepta los términos y condiciones',
                          );
                        }else{
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

    User? userFirebase =
        await _auth.signUpWithEmailAndPassword(email, password);
    setState(
      () {
        _isSigning = false;
      },
    );
    if (userFirebase != null) {
      AppUser.User user = AppUser.User(
        id: userFirebase.uid,
        email: email,
        idNIT: idController.text,
        userName: email.split('@')[0],
        name: nameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        termsAccepted: termsAccepted,
        description: '',
        type: userType!,
        facebookLink: '',
        instagramLink: '',

      );

      String userId = await _userController.createUser(user) ?? '';

      if (userId.isNotEmpty && userId != '') {
        showToast(
          message: 'Usuario creado con éxito',
        );

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(userId: userId), // Pasa el ID del usuario a HomePage
          ),
        );
      } else {
        showToast(
          message: 'Hubo un error al crear el usuario',
        );
      }
    } else {
      showToast(
        message: "Hubo un error inesperado",
      );
    }
  }
}
