import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;



  Future<User?> signUpWithEmailAndPasswod(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Algun error ocurrio durante el registro: $e");
    } 

    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Algun error ocurrio durante el registro: $e");
    } 

    return null;
  }

}