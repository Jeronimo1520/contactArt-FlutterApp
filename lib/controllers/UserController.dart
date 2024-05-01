import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/models/User.dart';

class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final String collection = "users";

  Future<String> createUser(User user) async {
    try {
      DocumentReference docRef =
          await db.collection(collection).add(user.toJson());
      return docRef.id;
    } catch (e) {
      print(e);
      return "";
    }
  }
}
