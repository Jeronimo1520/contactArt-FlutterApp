import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController {
  Stream<QuerySnapshot> getProductsStream() {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }
}