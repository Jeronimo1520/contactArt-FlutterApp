class User{
  String? id;
  String email;
  String idNIT;
  String userName;
  String name;
  String lastName;
  String phone;
  bool termsAccepted;
  String type;
  String? photoUrl;
  String? description;
  String? facebookLink;
  String? instagramLink;

  User({
    this.id,
    required this.email,
    required this.idNIT,
    required this.userName,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.termsAccepted,
    required this.type,
    this.photoUrl,
    this.description,
    this.facebookLink,
    this.instagramLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'idNIT': idNIT,
      'userName': userName,
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'termsAccepted': termsAccepted,
      'type': type,
      'photoUrl': photoUrl,
      'description': description,
      'facebookLink': facebookLink,
      'instagramLink': instagramLink,
    };
  }
}