import 'package:flutter/foundation.dart';

class Cart {
  String name;
  String price;
  String img;
  int quantity;
  String userId;

  Cart(
      {required this.name,
      required this.price,
      required this.img,
      required this.quantity,
      required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'img': img,
      'quantity': quantity,
      'userId': userId,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      name: json['name'],
      price: json['price'],
      img: json['img'],
      quantity: json['quantity'],
      userId: json['userId'],
    );
  }
}
