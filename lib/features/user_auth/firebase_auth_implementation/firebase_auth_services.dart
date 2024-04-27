import 'package:contact_art/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPasswod(String email, String password) async {
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
            message: 'Correo o contraseña incorrectos:',);
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
      } else {
        showToast(
            message: 'Correo o contraseña incorrectos:',);
      }
    }

    return null;
  }
}
