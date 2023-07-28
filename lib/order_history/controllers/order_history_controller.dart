import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_user/models/order.dart' as model;

class OrderHistoryController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<model.Order>> fetchOrderHistory() async {
    List<model.Order> ordersList = [];
    var orderSnapshot = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .orderBy('time', descending: true)
        .get();
    for (var tempData in orderSnapshot.docs) {
      model.Order tempOrder = model.Order.fromMap(tempData.data());
      if (tempOrder.isCancelled || tempOrder.isDelivered) {
        ordersList.add(tempOrder);
      }
    }

    return ordersList;
  }
}
