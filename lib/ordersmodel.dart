class OrderModel {
  late String trackingId;
  late String packageContent;
  late String pickupAdrs;
  late String deliveryAdrs;
  late String pickupPin;
  late String deliveryPin;
  late double weight;
  late double length;
  late double breadth;
  late double height;
  late double packageValue;
  late String orderStatus;
  late String pickupTime;
  late String uid;
  late String vid;
  late String shipmentType;

  OrderModel(
      {required this.trackingId,
      required this.uid,
      required this.vid,
      required this.packageContent,
      required this.pickupAdrs,
      required this.deliveryAdrs,
      required this.weight,
      required this.length,
      required this.breadth,
      required this.height,
      required this.packageValue,
      required this.orderStatus,
      required this.deliveryPin,
      required this.pickupPin,
      required this.shipmentType,
      required this.pickupTime});

  Map<String, dynamic> toMap() => {
        'trackingId': trackingId,
        'vid': vid,
        'uid': uid,
        'packageContent': packageContent,
        'pickupAdrs': pickupAdrs,
        'deliveryAdrs': deliveryAdrs,
        'pickupPin': pickupPin,
        'deliveryPin': deliveryPin,
        'weight': weight,
        'length': length,
        'breadth': breadth,
        'height': height,
        'packageValue': packageValue,
        'orderStatus': orderStatus,
        'pickupTime': pickupTime,
        'shipmentType': shipmentType,
      };

  OrderModel.fromMap(Map<String, dynamic> map)
      : trackingId = map['trackingId'] ?? "",
        vid = map['vid'] ?? "",
        uid = map['uid'] ?? "",
        packageContent = map['packageContent'] ?? "",
        pickupAdrs = map['pickupAdrs'] ?? "",
        deliveryAdrs = map['deliveryAdrs'] ?? "",
        deliveryPin = map['deliveryPin'] ?? "",
        pickupPin = map['pickupPin'] ?? "",
        weight = map['weight'] ?? "",
        length = map['length'] ?? "",
        breadth = map['breadth'] ?? "",
        height = map['height'] ?? "",
        orderStatus = map["orderStatus"] ?? "",
        packageValue = map['packageValue'] ?? "",
        shipmentType = map['shipmentType'] ?? "",
        pickupTime = map['pickupTime'] ?? "";
}
