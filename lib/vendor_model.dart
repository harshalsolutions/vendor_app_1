class VendorModel {
  String name;
  String companyName;
  String phone;
  String email;
  String address;
  String image;
  String vid;

  VendorModel(
      {required this.name,
      required this.companyName,
      required this.phone,
      required this.email,
      required this.address,
      required this.image,
      required this.vid});

  Map<String, dynamic> toMap() => {
        'name': name,
        'companyName': companyName,
        'phone': phone,
        'email': email,
        'address': address,
        'image': image,
        'vid': vid,
      };

  VendorModel.fromMap(Map<String, dynamic> map)
      : name = map['name'] ?? "",
        companyName = map['companyName'] ?? "",
        phone = map['phone'] ?? "",
        email = map['email'] ?? "",
        address = map['address'] ?? "",
        image = map['image'] ?? "",
        vid = map['vid'] ?? "";
}
