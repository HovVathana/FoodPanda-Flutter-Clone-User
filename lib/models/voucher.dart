import 'dart:convert';

class Voucher {
  String id;
  String name;
  bool isNewUser;
  int startingDate;
  int expiredDate;
  int createdDate;
  double? minPrice;
  double? discountPrice;
  double? discountPercentage;
  bool freeDelivery;

  Voucher({
    required this.id,
    required this.name,
    required this.isNewUser,
    required this.startingDate,
    required this.expiredDate,
    required this.createdDate,
    required this.minPrice,
    this.discountPrice,
    this.discountPercentage,
    required this.freeDelivery,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isNewUser': isNewUser,
      'startingDate': startingDate,
      'expiredDate': expiredDate,
      'createdDate': createdDate,
      'minPrice': minPrice,
      'discountPrice': discountPrice,
      'discountPercentage': discountPercentage,
      'freeDelivery': freeDelivery,
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      id: map['id'] as String,
      name: map['name'] as String,
      isNewUser: map['isNewUser'] as bool,
      startingDate: map['startingDate'] as int,
      expiredDate: map['expiredDate'] as int,
      createdDate: map['createdDate'] as int,
      minPrice: map['minPrice'] != null ? map['minPrice'] as double : null,
      discountPrice:
          map['discountPrice'] != null ? map['discountPrice'] as double : null,
      discountPercentage: map['discountPercentage'] != null
          ? map['discountPercentage'] as double
          : null,
      freeDelivery: map['freeDelivery'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Voucher.fromJson(String source) =>
      Voucher.fromMap(json.decode(source) as Map<String, dynamic>);
}
