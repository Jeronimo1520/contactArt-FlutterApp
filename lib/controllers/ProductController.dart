import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_art/models/Product.dart';

class ProductController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final String collection = "products";

  Future<String> createProduct(Product product) async {
    try {
      DocumentReference docRef =
          await db.collection(collection).add(product.toJson());
      return docRef.id;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<Product> getProduct(String productId) async {
    try {
      DocumentSnapshot docSnapshot =
          await db.collection(collection).doc(productId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        return Product.fromJson(data);
      } else {
        throw Exception('Producto no encontrado');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Stream<QuerySnapshot> getProductsStream() {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }
}
