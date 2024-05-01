import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/models/User.dart';

class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final String collection = "users";

  Future<void> createUser(User user) async {
    try {
      await db.collection(collection).add(user.toJson());
      
    } catch (e) {
      print(e);
    }
  }
}
