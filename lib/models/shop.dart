// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Shop {
  String uid;
  String shopName;
  String shopDescription;
  int? remainingTime;
  double? deliveryPrice;
  String shopImage;
  double rating;
  double totalRating;
  String houseNumber;
  String street;
  String area;
  double latitude;
  double longitude;
  String province;
  String floor;
  bool isApproved;

  Shop({
    required this.uid,
    required this.shopName,
    required this.shopDescription,
    this.remainingTime,
    this.deliveryPrice,
    required this.shopImage,
    required this.rating,
    required this.totalRating,
    required this.houseNumber,
    required this.street,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.province,
    required this.floor,
    required this.isApproved,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'shopName': shopName,
      'shopDescription': shopDescription,
      'remainingTime': remainingTime,
      'deliveryPrice': deliveryPrice,
      'shopImage': shopImage,
      'rating': rating,
      'totalRating': totalRating,
      'houseNumber': houseNumber,
      'street': street,
      'area': area,
      'latitude': latitude,
      'longitude': longitude,
      'province': province,
      'floor': floor,
      'isApproved': isApproved,
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      uid: map['uid'] ?? '',
      shopName: map['shopName'] ?? '',
      shopDescription: map['shopDescription'] ?? '',
      remainingTime: map['remainingTime']?.toInt() ?? 0,
      deliveryPrice: map['deliveryPrice']?.toDouble() ?? 0.0,
      shopImage: map['shopImage'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      totalRating: map['totalRating'].toDouble() ?? 0.0,
      houseNumber: map['houseNumber'] ?? '',
      street: map['street'] ?? '',
      area: map['area'] ?? '',
      latitude: map['latitude'].toDouble() ?? 0.0,
      longitude: map['longitude'].toDouble() ?? 0.0,
      province: map['province'] ?? '',
      floor: map['floor'] ?? '',
      isApproved: map['isApproved'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Shop.fromJson(String source) =>
      Shop.fromMap(json.decode(source) as Map<String, dynamic>);
}
