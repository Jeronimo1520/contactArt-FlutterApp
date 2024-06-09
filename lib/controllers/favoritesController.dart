import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/models/Favorites.dart';

class FavoritesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId;

  FavoritesController(this.userId);

  Future<Favorites> loadFavorites() async {
    var doc = await _firestore.collection('favorites').doc(userId).get();
    if (doc.exists) {
      return Favorites(productIds: List<String>.from(doc.data()?['favorites']));
    } else {
      return Favorites(productIds: []);
    }
  }

  Future<bool> addFavorite(String productId) async {
    var doc = await _firestore.collection('favorites').doc(userId).get();
    if (doc.exists) {
      List<String> favorites = List<String>.from(doc.data()?['favorites']);
      favorites.add(productId);
      await doc.reference.update({'favorites': favorites, 'userId': userId});
      return true;
    } else {
      await doc.reference.set({
        'favorites': [productId],
        'userId': userId
      });
      return true;
    }
    return false;
  }

  Future<void> removeFavorite(String productId) async {
    var doc = await _firestore.collection('favorites').doc(userId).get();
    if (doc.exists) {
      List<String> favorites = List<String>.from(doc.data()?['favorites']);
      favorites.remove(productId);
      await doc.reference.update({'favorites': favorites, 'userId': userId});
    }
  }

  Future<bool> isFavorite(String productId) async {
    var doc = await _firestore.collection('favorites').doc(userId).get();
    if (doc.exists) {
      List<String> favorites = List<String>.from(doc.data()?['favorites']);
      return favorites.contains(productId);
    } else {
      return false;
    }
  }
}
