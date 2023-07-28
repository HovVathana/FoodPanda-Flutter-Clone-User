import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/models/voucher.dart';

class VoucherController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<dynamic> searchVoucher({
    required String query,
  }) async {
    query = query.toUpperCase();

    var result = await firestore
        .collection('vouchers')
        .where('name', isEqualTo: query)
        .get();

    if (result.docs.isEmpty) {
      return 'This voucher does not exist. Please check if the voucher code was keyed in correctly.';
    } else {
      Voucher voucher = Voucher.fromMap(result.docs[0].data());
      if (DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(voucher.expiredDate))) {
        return 'Sorry, this voucher has expired. Please check the T&Cs.';
      }

      if (voucher.isNewUser) {
        var orders = await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('orders')
            .where('isCancelled', isEqualTo: false)
            .get();

        if (orders.docs.isNotEmpty) {
          return 'Sorry, this voucher is only valid for a new customer\'s first purchase.';
        }
      }

      String? errorText = await saveVoucher(voucherId: voucher.id);
      return errorText != null ? errorText : voucher;
    }
  }

  Future<String?> saveVoucher({required String voucherId}) async {
    final DocumentReference ref;
    String? errorText;

    ref = firestore
        .collection('saved_vouchers')
        .doc(firebaseAuth.currentUser!.uid);

    await ref.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (data['voucherId'].toString().contains(voucherId)) {
          errorText = 'You\'ve already saved this one! Find it in Vouchers';
        }
        await ref.update({
          'voucherId': FieldValue.arrayUnion([voucherId]),
        }).catchError((error) {
          debugPrint(error);
        });
      } else {
        await ref.set({
          'voucherId': [voucherId],
        }).catchError((error) {
          debugPrint(error);
        });
      }
    });
    return errorText;
  }

  Future<bool> checkIfSavedVoucher({required String voucherId}) async {
    final DocumentReference ref;
    bool isChecked = false;

    ref = firestore
        .collection('saved_vouchers')
        .doc(firebaseAuth.currentUser!.uid);

    await ref.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (data['voucherId'].toString().contains(voucherId)) {
          isChecked = true;
        }
      }
    });
    return isChecked;
  }

  Future<List<Voucher>> fetchSavedVouchers() async {
    return firestore
        .collection('saved_vouchers')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then(
      (event) async {
        List<Voucher> vouchers = [];
        var doc = event.data();
        var voucherId = doc != null ? doc['voucherId'] : [];
        voucherId = voucherId ?? [];

        for (int i = 0; i < voucherId.length; i++) {
          Voucher? tempVoucher =
              await fetchVoucherById(voucherId: voucherId[i]);
          if (tempVoucher != null) {
            vouchers.add(tempVoucher);
          }
        }

        vouchers.sort((b, a) => a.createdDate.compareTo(b.createdDate));

        return vouchers;
      },
    );
  }

  Future<List<String>> fetchUsedVouchers() async {
    return firestore
        .collection('saved_vouchers')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then(
      (event) async {
        List<String> usedVoucher = [];
        var doc = event.data();
        var voucherId = doc != null ? doc['usedVoucher'] : [];
        voucherId = voucherId ?? [];

        for (int i = 0; i < voucherId.length; i++) {
          usedVoucher.add(voucherId[i]);
        }
        return usedVoucher;
      },
    );
  }

  Future<Voucher?> fetchVoucherById({
    required String voucherId,
  }) async {
    var voucherData =
        await firestore.collection('vouchers').doc(voucherId).get();

    Voucher? voucher;
    if (voucherData.data() != null) {
      Voucher tempVoucher = Voucher.fromMap(voucherData.data()!);
      if (DateTime.now().isAfter(
          DateTime.fromMillisecondsSinceEpoch(tempVoucher.expiredDate))) {
        voucher = null;
      } else {
        voucher = tempVoucher;
      }
    }

    return voucher;
  }

  Future markVoucherAsUsed({
    required String voucherId,
  }) async {
    final DocumentReference ref;

    ref = firestore
        .collection('saved_vouchers')
        .doc(firebaseAuth.currentUser!.uid);

    await ref.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (!data['usedVoucher'].toString().contains(voucherId)) {
          await ref.update({
            'usedVoucher': FieldValue.arrayUnion([voucherId]),
          }).catchError((error) {
            debugPrint(error);
          });
        }
      } else {
        await ref.set({
          'usedVoucher': [voucherId],
        }).catchError((error) {
          debugPrint(error);
        });
      }
    });
  }

  Future unmarkVoucherAsUsed({
    required String voucherId,
  }) async {
    final DocumentReference ref;

    ref = firestore
        .collection('saved_vouchers')
        .doc(firebaseAuth.currentUser!.uid);

    await ref.get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        await ref.update({
          'usedVoucher': FieldValue.arrayRemove([voucherId]),
        }).catchError((error) {
          debugPrint(error);
        });
      }
    });
  }
}
