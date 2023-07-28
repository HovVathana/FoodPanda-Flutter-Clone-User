// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:foodpanda_user/models/address.dart';
import 'package:foodpanda_user/models/rider.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/models/user.dart';

class FoodOrder {
  String foodName;
  int quantity;
  double foodPrice;
  String customize;
  FoodOrder({
    required this.foodName,
    required this.quantity,
    required this.foodPrice,
    required this.customize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foodName': foodName,
      'quantity': quantity,
      'foodPrice': foodPrice,
      'customize': customize,
    };
  }

  factory FoodOrder.fromMap(Map<String, dynamic> map) {
    return FoodOrder(
      foodName: map['foodName'] as String,
      quantity: map['quantity'] as int,
      foodPrice: map['foodPrice'] as double,
      customize: map['customize'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodOrder.fromJson(String source) =>
      FoodOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Order {
  String? id;
  User user;
  Address address;
  Shop shop;
  List<FoodOrder> foodOrders;
  double totalPrice;
  double deliveryPrice;
  double discountPrice;
  String? voucherId;
  bool isPaid;
  bool isShopAccept;
  bool isRiderAccept;
  bool isPickup;
  bool isNear;
  bool isDelivered;
  bool isCancelled;
  bool isCutlery;
  int time;
  int? deliveredTime;
  Rider? rider;
  Order({
    this.id,
    required this.user,
    required this.address,
    required this.shop,
    required this.foodOrders,
    required this.totalPrice,
    required this.deliveryPrice,
    required this.discountPrice,
    this.voucherId,
    this.isPaid = false,
    this.isShopAccept = false,
    this.isRiderAccept = false,
    this.isPickup = false,
    this.isNear = false,
    this.isDelivered = false,
    this.isCancelled = false,
    this.isCutlery = false,
    required this.time,
    this.deliveredTime,
    this.rider,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'address': address.toMap(),
      'shop': shop.toMap(),
      'foodOrders': foodOrders.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'deliveryPrice': deliveryPrice,
      'discountPrice': discountPrice,
      'voucherId': voucherId,
      'isPaid': isPaid,
      'isShopAccept': isShopAccept,
      'isRiderAccept': isRiderAccept,
      'isPickup': isPickup,
      'isNear': isNear,
      'isDelivered': isDelivered,
      'isCancelled': isCancelled,
      'isCutlery': isCutlery,
      'time': time,
      'deliveredTime': deliveredTime,
      'rider': rider?.toMap(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] != null ? map['id'] as String : null,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
      shop: Shop.fromMap(map['shop'] as Map<String, dynamic>),
      foodOrders: List<FoodOrder>.from(
        (map['foodOrders']).map<FoodOrder>(
          (x) => FoodOrder.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: map['totalPrice'] as double,
      deliveryPrice: map['deliveryPrice'] as double,
      discountPrice: map['discountPrice'] as double,
      voucherId: map['voucherId'] != null ? map['voucherId'] as String : null,
      isPaid: map['isPaid'] != null ? map['isPaid'] as bool : false,
      isShopAccept:
          map['isShopAccept'] != null ? map['isShopAccept'] as bool : false,
      isRiderAccept:
          map['isRiderAccept'] != null ? map['isRiderAccept'] as bool : false,
      isPickup: map['isPickup'] != null ? map['isPickup'] as bool : false,
      isNear: map['isNear'] != null ? map['isNear'] as bool : false,
      isDelivered:
          map['isDelivered'] != null ? map['isDelivered'] as bool : false,
      isCancelled:
          map['isCancelled'] != null ? map['isCancelled'] as bool : false,
      isCutlery: map['isCutlery'] != null ? map['isCutlery'] as bool : false,
      time: map['time'] as int,
      deliveredTime: map['deliveredTime']?.toInt() ?? 0,
      rider: map['rider'] != null
          ? Rider.fromMap(map['rider'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
