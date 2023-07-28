import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double? _latitude;
  double? get latitude => _latitude;

  double? _longitude;
  double? get longitude => _longitude;

  Address? _address;
  Address? get address => _address;

  bool _isCurrentLocation = true;
  bool get isCurrentLocation => _isCurrentLocation;

  Future getAddressFromSharedPreference() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? addressString = sharedPreferences.getString('address');
    if (addressString == null) {
      await getCurrentLocation();
      await getPlacemarks();
    } else {
      Address spAddress = Address.fromMap(jsonDecode(addressString));
      _address = spAddress;
      _latitude = spAddress.latitude;
      _longitude = spAddress.longitude;
      _isCurrentLocation =
          sharedPreferences.getBool('isCurrentLocationAddress') ?? false;
    }
    notifyListeners();
  }

  Future getCurrentLocation() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position != null) {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _isCurrentLocation = true;
      await sharedPreferences.setBool('isCurrentLocationAddress', true);
      notifyListeners();
    } else {
      print('Permission not allowed');
    }
  }

  Future setLocationManually(LatLng latLng) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    _latitude = latLng.latitude;
    _longitude = latLng.longitude;
    _isCurrentLocation = false;
    await sharedPreferences.setBool('isCurrentLocationAddress', false);
    notifyListeners();
  }

  Future clear() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.remove('isCurrentLocationAddress');
    await sharedPreferences.remove('address');
  }

  Future selectAddress(Address selectedAddress) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    _address = selectedAddress;
    _latitude = selectedAddress.latitude;
    _longitude = selectedAddress.longitude;
    _isCurrentLocation = false;

    await sharedPreferences.setString(
        'address', jsonEncode(selectedAddress.toMap()));
    await sharedPreferences.setBool('isCurrentLocationAddress', false);

    notifyListeners();
  }

  Future getPlacemarks() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latitude!, _longitude!);

    if (placemarks.length > 0) {
      Address newAddress = Address(
        houseNumber: placemarks[0].subThoroughfare ?? '',
        street: placemarks[0].thoroughfare != null
            ? placemarks[0].thoroughfare!.replaceAll('Saint', 'St.')
            : '',
        area: placemarks[0].subLocality ?? '',
        province: placemarks[0].administrativeArea ?? '',
        latitude: _latitude!,
        longitude: _longitude!,
        floor: '',
        deliveryInstruction: '',
        label: '',
      );
      await sharedPreferences.setString(
          'address', jsonEncode(newAddress.toMap()));
      _address = newAddress;
      notifyListeners();
    }
  }
}
