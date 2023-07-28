import 'dart:convert';

class Food {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double comparePrice;
  final bool isPublished;
  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.comparePrice,
    required this.isPublished,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'comparePrice': comparePrice,
      'isPublished': isPublished,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      price: map['price'] as double,
      comparePrice: map['comparePrice'] as double,
      isPublished: map['isPublished'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Food.fromJson(String source) =>
      Food.fromMap(json.decode(source) as Map<String, dynamic>);
}
