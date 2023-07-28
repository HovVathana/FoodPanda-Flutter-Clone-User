import 'dart:convert';

class Category {
  final String title;
  final String subtitle;
  final String id;
  final bool isPublished;

  Category({
    required this.title,
    required this.subtitle,
    required this.id,
    required this.isPublished,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'id': id,
      'isPublished': isPublished,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      id: map['id'] ?? '',
      isPublished: map['isPublished'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
