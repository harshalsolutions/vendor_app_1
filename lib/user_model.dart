class UserModel {
  String? name;
  String? address;
  String phone;
  String email;
  String imgUrl;
  String uid;

  UserModel(
      {this.name,
      this.address,
      required this.phone,
      required this.email,
      required this.imgUrl,
      required this.uid});

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
        'imgUrl': imgUrl,
        'uid': uid,
      };

  UserModel.fromMap(Map map)
      : name = map['name'] ?? "",
        address = map['address'] ?? "",
        phone = map['phone'] ?? "",
        email = map['email'] ?? "",
        imgUrl = map['imgUrl'] ?? "",
        uid = map['uid'] ?? "";
}
