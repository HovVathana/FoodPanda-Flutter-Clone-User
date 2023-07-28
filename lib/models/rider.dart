// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:foodpanda_user/models/user.dart';

class Rider {
  User user;
  double latitude;
  double longitude;
  Rider({
    required this.user,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Rider.fromMap(Map<String, dynamic> map) {
    return Rider(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rider.fromJson(String source) =>
      Rider.fromMap(json.decode(source) as Map<String, dynamic>);
}
