import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/helper.dart';
import 'package:foodpanda_user/models/category.dart';
import 'package:foodpanda_user/models/customize.dart';
import 'package:foodpanda_user/models/food.dart';
import 'package:foodpanda_user/models/menu.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/models/banner.dart' as banner;

import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:provider/provider.dart';

class FoodDeliveryController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Shop>> fetchShop(BuildContext context) async {
    final lp = context.read<LocationProvider>();

    List<Shop> shops = [];

    var shopSnapshot = await firestore
        .collection('sellers')
        .where('isApproved', isEqualTo: true)
        .get();

    for (var tempData in shopSnapshot.docs) {
      if (tempData.data().containsKey('latitude')) {
        Shop tempShop = Shop.fromMap(tempData.data());
        double distance = Helper().calculateDistance(
          lp.address!.latitude,
          lp.address!.longitude,
          tempShop.latitude,
          tempShop.longitude,
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

        tempShop.deliveryPrice = double.parse(deliveryPrice.toStringAsFixed(2));
        tempShop.remainingTime = remainingTime;
        shops.add(tempShop);
      }
    }
    return shops;
  }

  Future<List<Menu>> fetchCategory({
    required String sellerUid,
  }) async {
    List<Menu> menu = [];
    var categoriesSnapshot = await firestore
        .collection('sellers')
        .doc(sellerUid)
        .collection('categories')
        .get();
    for (var tempData in categoriesSnapshot.docs) {
      Category tempCategory = Category.fromMap(tempData.data());
      if (tempCategory.isPublished) {
        List<Food> tempFoods = await fetchFood(
          sellerUid: sellerUid,
          categoriesId: tempCategory.id,
        );
        Menu tempMenu = Menu(category: tempCategory, foods: tempFoods);
        menu.add(tempMenu);
      }
    }

    return menu;
  }

  Future<List<Food>> fetchFood({
    required String sellerUid,
    required String categoriesId,
  }) async {
    List<Food> foods = [];
    var categoriesSnapshot = await firestore
        .collection('sellers')
        .doc(sellerUid)
        .collection('categories')
        .doc(categoriesId)
        .collection('foods')
        .get();
    for (var tempData in categoriesSnapshot.docs) {
      Food tempCategory = Food.fromMap(tempData.data());
      if (tempCategory.isPublished) {
        foods.add(tempCategory);
      }
    }

    return foods;
  }

  Future<List<Customize>> fetchCustomize(
      {required String sellerUid,
      required String categoriesId,
      required String foodId}) async {
    List<Customize> customize = [];
    var customizeSnapshot = await firestore
        .collection('sellers')
        .doc(sellerUid)
        .collection('categories')
        .doc(categoriesId)
        .collection('foods')
        .doc(foodId)
        .collection('customize')
        .orderBy('isVariation', descending: true)
        .orderBy('isRequired', descending: true)
        .get();
    for (var tempData in customizeSnapshot.docs) {
      Customize tempCustomize = Customize.fromMap(tempData.data());
      customize.add(tempCustomize);
    }

    return customize;
  }

  Future<List<banner.Banner>> fetchBanner() async {
    List<banner.Banner> banners = [];
    var bannerSnapShot = await firestore
        .collection('banners')
        .where('isApproved', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();
    for (var tempData in bannerSnapShot.docs) {
      banner.Banner tempBanner = banner.Banner.fromMap(tempData.data());

      banners.add(tempBanner);
    }

    return banners;
  }

  Future<Shop?> fetchShopById({
    required String shopId,
    required BuildContext context,
  }) async {
    final lp = context.read<LocationProvider>();

    var shopSnapshot = await firestore.collection('sellers').doc(shopId).get();

    Shop? shop =
        shopSnapshot.data() != null ? Shop.fromMap(shopSnapshot.data()!) : null;

    if (shop != null) {
      double distance = Helper().calculateDistance(
        lp.address!.latitude,
        lp.address!.longitude,
        shop.latitude,
        shop.longitude,
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

      shop.deliveryPrice = double.parse(deliveryPrice.toStringAsFixed(2));
      shop.remainingTime = remainingTime;
    }

    return shop;
  }
}
