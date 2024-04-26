import 'package:contact_art/features/user_auth/presentation/pages/home_page.dart';
import 'package:contact_art/features/user_auth/presentation/pages/signUp_page.dart';
import 'package:contact_art/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/features/app/splash_screen/splash_screen.dart';
import 'package:contact_art/features/user_auth/presentation/pages/login_page.dart';

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
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'ContactArt',
      home: SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}
