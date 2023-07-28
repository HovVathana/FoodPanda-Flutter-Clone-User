import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/models/order.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  model.Order? _currentOrder;
  model.Order? get currentOrder => _currentOrder;

  Future getOrderFromSharedPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? orderString = sharedPreferences.getString('currentOrder');
    if (orderString == null) {
      _currentOrder = null;
    } else {
      model.Order order = model.Order.fromMap(
        jsonDecode(
          orderString,
        ),
      );
      _currentOrder = order;
    }
    notifyListeners();
  }

  Future<String> saveOrderDetail(model.Order order) async {
    if (_currentOrder == null) {
      final DocumentReference userRef;
      final DocumentReference sellerRef;
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      userRef = firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('orders')
          .doc();

      sellerRef = firestore
          .collection('sellers')
          .doc(order.shop.uid)
          .collection('orders')
          .doc(userRef.id);

      order.id = userRef.id;

      _currentOrder = order;
      await sharedPreferences.setString(
        'currentOrder',
        jsonEncode(order.toMap()),
      );

      await userRef.set(order.toMap()).catchError((error) => error.toString());

      await sellerRef
          .set(order.toMap())
          .catchError((error) => error.toString());
      notifyListeners();

      return 'success';
    } else {
      return 'cannot place 2 orders at the same time';
    }
  }

  Future clearCurrentOrder() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.remove('currentOrder');
    _currentOrder = null;

    notifyListeners();
  }

  Future cancelOrder(model.Order order) async {
    if (!order.isShopAccept) {
      await firestore
          .collection('sellers')
          .doc(order.shop.uid)
          .collection('orders')
          .doc(order.id)
          .set(
        {
          "isCancelled": true,
        },
        SetOptions(merge: true),
      );

      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('orders')
          .doc(order.id)
          .set(
        {
          "isCancelled": true,
        },
        SetOptions(merge: true),
      );
    }
  }

  // Stream<model.Order> fetchOrderDetail({required String orderId}) {
  //   return firestore
  //       .collection('users')
  //       .doc(firebaseAuth.currentUser!.uid)
  //       .collection('orders')
  //       .doc(orderId)
  //       .snapshots()
  //       .map(
  //     (event) {
  //       model.Order order = model.Order.fromMap(event.data()!);
  //       print(event.data()!.toString());
  //       return order;
  //     },
  //   );
  // }

  Future detectChanges({required String orderId}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    DocumentReference reference = firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(orderId);
    reference.snapshots().listen((event) async {
      final Map<String, dynamic> doc = event.data() as Map<String, dynamic>;
      model.Order order = model.Order.fromMap(doc);

      if (order.isCancelled == true) {
        await clearCurrentOrder();
      } else {
        _currentOrder = order;
        await sharedPreferences.setString(
          'currentOrder',
          jsonEncode(order.toMap()),
        );
      }

      notifyListeners();
    });
  }
}
