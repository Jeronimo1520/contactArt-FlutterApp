import 'package:contact_art/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            message: 'El correo ya está en uso',
            backgroundColor: Colors.purple,
            textColor: Colors.white);
      } else {
        showToast(
            message: 'Correo o contraseña incorrectos: $e',
            backgroundColor: Colors.purple,
            textColor: Colors.white);
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
            message: 'Usuario no encontrado',
            backgroundColor: Colors.purple,
            textColor: Colors.white);
      } else if(e.code == 'wrong-password'){
        showToast(
            message: 'Contraseña incorrecta',
            backgroundColor: Colors.purple,
            textColor: Colors.white);
      } else {
        showToast(
            message: 'Correo o contraseña incorrectos: $e.code',
            backgroundColor: Colors.purple,
            textColor: Colors.white);
      }
    }

    return null;
  }
}
