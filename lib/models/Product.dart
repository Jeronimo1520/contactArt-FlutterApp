class Product {
  String? id;
  String price;
  String name;
  String img;
  String description;
  String category;

  Product({
    this.id,
    required this.price,
    required this.name,
    required this.img,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'name': name,
      'img': img,
      'description': description,
      'category': category,
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
    );
  }
}
