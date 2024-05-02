import 'package:contact_art/features/app/presentation/pages/addProduct.dart';
import 'package:contact_art/features/app/presentation/pages/editProfile.dart';
import 'package:contact_art/features/app/presentation/pages/homePage.dart';
import 'package:contact_art/features/app/presentation/pages/profile.dart';
import 'package:contact_art/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/features/app/presentation/splash_screen/splashScreen.dart';
import 'package:contact_art/features/app/presentation/pages/loginPage.dart';

import 'features/app/presentation/pages/signUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ).then((value) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(userId: "",),
        '/editProfile': (context) => EditProfilePage(),
        '/addProduct': (context) => AddProductPage(),
        '/perfil': (context) => ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'ContactArt',
      home: SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}
