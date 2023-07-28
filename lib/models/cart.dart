// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:foodpanda_user/models/customize.dart';
import 'package:foodpanda_user/models/food.dart';
import 'package:foodpanda_user/models/shop.dart';

class Cart {
  Shop shop;
  Food food;
  String categoriesId;
  String customize;
  double price;
  double deliveryPrice;
  int quantity;
  List<Choice> requiredSelectedChoice;
  List<Choice> optionalSelectedChoice;
  List<List<bool>> optionalIsSelected;
  Cart({
    required this.shop,
    required this.food,
    required this.categoriesId,
    required this.customize,
    required this.price,
    required this.deliveryPrice,
    required this.quantity,
    required this.requiredSelectedChoice,
    required this.optionalSelectedChoice,
    required this.optionalIsSelected,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shop': shop.toMap(),
      'food': food.toMap(),
      'categoriesId': categoriesId,
      'customize': customize,
      'price': price,
      'deliveryPrice': deliveryPrice,
      'quantity': quantity,
      'requiredSelectedChoice': requiredSelectedChoice,
      'optionalSelectedChoice': optionalSelectedChoice,
      'optionalIsSelected': optionalIsSelected,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      shop: Shop.fromMap(map['shop'] as Map<String, dynamic>),
      food: Food.fromMap(map['food'] as Map<String, dynamic>),
      categoriesId: map['categoriesId'] as String,
      customize: map['customize'] as String,
      price: map['price'] as double,
      deliveryPrice: map['deliveryPrice'] as double,
      quantity: map['quantity'] as int,
      requiredSelectedChoice: List<Choice>.from(
        (map['requiredSelectedChoice']).map<Choice>(
          (x) => Choice.fromMap(jsonDecode(x)),
        ),
      ),
      optionalSelectedChoice: List<Choice>.from(
        (map['optionalSelectedChoice']).map<Choice>(
          (x) => Choice.fromMap(jsonDecode(x)),
        ),
      ),
      optionalIsSelected: List<List<bool>>.from(map["optionalIsSelected"]
          .map((x) => List<bool>.from(x.map((x) => x)))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);
}
