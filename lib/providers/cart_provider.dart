import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/helper.dart';
import 'package:foodpanda_user/models/cart.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Cart> _cart = [];
  List<Cart> get cart => _cart;

  // CartProvider() {
  //   getCartFromSharedPreferences();
  // }

  Future getCartFromSharedPreferences(BuildContext context) async {
    final lp = context.read<LocationProvider>();

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    List<String> cartListString = sharedPreferences.getStringList('cart') ?? [];

    List<Cart> cartList = [];

    for (int i = 0; i < cartListString.length; i++) {
      Cart eachCart = Cart.fromMap(jsonDecode(cartListString[i]));
      double distance = Helper().calculateDistance(
        lp.address!.latitude,
        lp.address!.longitude,
        eachCart.shop.latitude,
        eachCart.shop.longitude,
      );
      double deliveryPrice = distance <= 0.5
          ? 0
          : distance <= 1
              ? 0.3
              : distance * 0.3;

      int remainingTime = distance < 1
          ? 10
          : distance < 2
              ? 15
              : distance < 3
                  ? 20
                  : 25;

      eachCart.shop.deliveryPrice =
          double.parse(deliveryPrice.toStringAsFixed(2));
      eachCart.shop.remainingTime = remainingTime;
      cartList.add(eachCart);
    }

    _cart = cartList;

    notifyListeners();
  }

  Future addCart({
    required Cart cartData,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    _cart.add(cartData);

    List<String> cartMapList = [];
    for (int i = 0; i < _cart.length; i++) {
      Map<String, dynamic> cartMap = _cart[i].toMap();
      cartMapList.add(jsonEncode(cartMap));
    }

    await sharedPreferences.setStringList('cart', cartMapList);

    notifyListeners();
  }

  Future editCart({
    required int index,
    required Cart cartData,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _cart[index] = cartData;

    List<String> cartMapList = [];
    for (int i = 0; i < _cart.length; i++) {
      Map<String, dynamic> cartMap = _cart[i].toMap();
      cartMapList.add(jsonEncode(cartMap));
    }

    await sharedPreferences.setStringList('cart', cartMapList);

    notifyListeners();
  }

  Future removeCart({
    required int index,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _cart.removeAt(index);

    List<String> cartMapList = [];
    for (int i = 0; i < _cart.length; i++) {
      Map<String, dynamic> cartMap = _cart[i].toMap();
      cartMapList.add(jsonEncode(cartMap));
    }

    await sharedPreferences.setStringList('cart', cartMapList);

    notifyListeners();
  }

  Future changeQuantity({required int index, required int quantity}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _cart[index] = Cart(
      shop: _cart[index].shop,
      food: _cart[index].food,
      categoriesId: _cart[index].categoriesId,
      customize: _cart[index].customize,
      price: _cart[index].price,
      deliveryPrice: _cart[index].deliveryPrice,
      quantity: quantity,
      requiredSelectedChoice: _cart[index].requiredSelectedChoice,
      optionalSelectedChoice: _cart[index].optionalSelectedChoice,
      optionalIsSelected: _cart[index].optionalIsSelected,
    );

    List<String> cartMapList = [];
    for (int i = 0; i < _cart.length; i++) {
      Map<String, dynamic> cartMap = _cart[i].toMap();
      cartMapList.add(jsonEncode(cartMap));
    }

    await sharedPreferences.setStringList('cart', cartMapList);

    notifyListeners();
  }

  Future clearCart() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.remove('cart');
    _cart = [];
    notifyListeners();
  }
}
