import 'dart:convert';

class ItemModel {
  String name;
  String subtitle;
  int remainingTime;
  double deliveryPrice;
  String image;
  double rating;
  double totalRating;

  ItemModel({
    required this.name,
    required this.subtitle,
    required this.remainingTime,
    required this.deliveryPrice,
    required this.image,
    required this.rating,
    required this.totalRating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'subtitle': subtitle,
      'remainingTime': remainingTime,
      'deliveryPrice': deliveryPrice,
      'image': image,
      'rating': rating,
      'totalRating': totalRating,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'] as String,
      subtitle: map['subtitle'] as String,
      remainingTime: map['remainingTime'] as int,
      deliveryPrice: map['deliveryPrice'] as double,
      image: map['image'] as String,
      rating: map['rating'] as double,
      totalRating: map['totalRating'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
