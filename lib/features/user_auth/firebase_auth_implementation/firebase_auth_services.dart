import 'package:contact_art/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(
            message: 'El correo ya está en uso',);
      } else {
        showToast(
            message: 'Correo o contraseña incorrectos',);
      }
    }

    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        showToast(
            message: 'Usuario no encontrado',);
      } else if(e.code == 'wrong-password'){
        showToast(
            message: 'Contraseña incorrecta',);
      } else if (e.code == 'invalid-credential'){
        print(e.code);
        showToast(
            message: 'Credenciales invalidas o no encontradas',);
      }
    }

    return null;
  }

  Future<User?> signInWithGoogle() async {
  // Inicializa el cliente de Google Sign In
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Intenta iniciar sesión
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  if (googleUser == null) {
    // Si el usuario cancela el inicio de sesión, regresa null
    return null;
  }

  // Autentica con Firebase usando la credencial de Google
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  try {
    // Inicia sesión en Firebase
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    // Maneja los errores de autenticación
    print(e);
    return null;
  }
}
}
