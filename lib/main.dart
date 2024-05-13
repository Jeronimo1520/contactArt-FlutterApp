import 'package:contact_art/controllers/cartController.dart';
import 'package:contact_art/controllers/userProvider.dart';
import 'package:contact_art/features/app/presentation/pages/addProduct.dart';
import 'package:contact_art/features/app/presentation/pages/cartPage.dart';
import 'package:contact_art/features/app/presentation/pages/editProfile.dart';
import 'package:contact_art/features/app/presentation/pages/homePage.dart';
import 'package:contact_art/features/app/presentation/pages/myProducts.dart';
import 'package:contact_art/features/app/presentation/pages/profile.dart';
import 'package:contact_art/firebase_options.dart';
import 'package:contact_art/models/Cart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:contact_art/features/app/presentation/splash_screen/splashScreen.dart';
import 'package:contact_art/features/app/presentation/pages/loginPage.dart';
import 'package:provider/provider.dart';

import 'features/app/presentation/pages/signUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => runApp(
            MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => UserProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => CartController(),
                ),
              ],
              child: const MainApp(),
            ),
          ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => const HomePage(),
        '/editProfile': (context) => const EditProfilePage(),
        '/addProduct': (context) => AddProductPage(),
        '/perfil': (context) => ProfilePage(),
        '/carrito': (context) => CartPage(),
        '/products': (context) => MyProductsPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'ContactArt',
      home: const SplashScreen(
        child: LoginPage(),
      ),
    );
  }
}
