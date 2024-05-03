import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/models/User.dart';

class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final String collection = "users";

  Future<String?> createUser(User user) async {
    try {
          await db.collection(collection).doc(user.id).set(user.toJson());
      return user.id;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<User> getUser(String userId) async {
    try {
      DocumentSnapshot docSnapshot =
          await db.collection(collection).doc(userId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        return User.fromJson(data);
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
