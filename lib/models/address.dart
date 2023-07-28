// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Address {
  final String? id;
  final String houseNumber;
  final String street;
  final String area;
  final double latitude;
  final double longitude;
  final String province;
  final String floor;
  final String? deliveryInstruction;
  final String? label;
  Address({
    this.id,
    required this.houseNumber,
    required this.street,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.province,
    required this.floor,
    this.deliveryInstruction,
    this.label,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'houseNumber': houseNumber,
      'street': street,
      'area': area,
      'latitude': latitude,
      'longitude': longitude,
      'province': province,
      'floor': floor,
      'deliveryInstruction': deliveryInstruction,
      'label': label,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] != null ? map['id'] as String : null,
      houseNumber: map['houseNumber'] as String,
      street: map['street'] as String,
      area: map['area'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      province: map['province'] as String,
      floor: map['floor'] as String,
      deliveryInstruction: map['deliveryInstruction'] != null
          ? map['deliveryInstruction'] as String
          : '',
      label: map['label'] != null ? map['label'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);
}
