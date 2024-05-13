class Product {
  String? id;
  String price;
  String name;
  String img;
  String description;
  String category;
  String userId;

  Product({
    this.id,
    required this.price,
    required this.name,
    required this.img,
    required this.description,
    required this.category,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'name': name,
      'img': img,
      'description': description,
      'category': category,
      'userId': userId,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['price'],
      name: json['name'],
      img: json['img'],
      description: json['description'],
      category: json['category'],
      userId: json['userId'],
    );
  }
}
