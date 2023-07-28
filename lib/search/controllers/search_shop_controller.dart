import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchShopController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Shop>> fetchSearchResult({
    required String search,
  }) async {
    List<Shop> shopList = [];
    var shopSnapshot = await firestore
        .collection('sellers')
        .where(
          'shopName',
          isGreaterThanOrEqualTo: search.toUpperCase(),
        )
        .get();

    for (var tempData in shopSnapshot.docs) {
      Shop tempShop = Shop.fromMap(tempData.data());
      if (tempShop.isApproved) {
        shopList.add(tempShop);
      }
    }

    return shopList;
  }

  Future<List<String>> getSearchHistory() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    List<String> searchHistory =
        sharedPreferences.getStringList('searchHistory') ?? [];
    return searchHistory;
  }

  Future saveSearchHistory({
    required String search,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    List<String> searchHistory =
        sharedPreferences.getStringList('searchHistory') ?? [];

    await sharedPreferences
        .setStringList('searchHistory', [search, ...searchHistory]);
  }

  Future removeSearchHistory({
    required List<String> searchHistory,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setStringList('searchHistory', searchHistory);
  }
}
