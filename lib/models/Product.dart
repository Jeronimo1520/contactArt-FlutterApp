class Product{
  String? id;
  String price;
  String name;
  String img1;
  String description;
  String category;

  Product({
    this.id,
    required this.price,
    required this.name,
    required this.img1,
    required this.description,
    required this.category,
    
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'name': name,
      'img1': img1,
      'description': description,
      'category': category,
      
    };
  }
}