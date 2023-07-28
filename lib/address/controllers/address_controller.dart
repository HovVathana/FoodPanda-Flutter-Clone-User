import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_user/models/address.dart';

class AddressController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future saveAddressToFirestore({required Address address, String? id}) async {
    final DocumentReference ref;

    if (id != null) {
      ref = firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('address')
          .doc(id);
    } else {
      ref = firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('address')
          .doc();
    }

    await ref.set({
      'area': address.area,
      'deliveryInstruction': address.deliveryInstruction,
      'floor': address.floor,
      'houseNumber': address.houseNumber,
      'label': address.label,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'province': address.province,
      'street': address.street,
      'id': ref.id,
    }).catchError((error) {
      print(error);
    });

    return ref.id;
  }

  Future deleteAddress({
    required String id,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('address')
        .doc(id);

    await ref.delete().catchError((error) {
      print(error);
    });
  }

  Stream<List<Address>> fetchAddress() {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('address')
        .snapshots()
        .map(
      (event) {
        List<Address> addresses = [];
        for (var document in event.docs) {
          addresses.add(Address.fromMap(document.data()));
        }
        return addresses;
      },
    );
  }

  Future<List<Address>> fetchAddressArray() async {
    List<Address> address = [];
    var addressSnapshot = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('address')
        .get();
    for (var tempData in addressSnapshot.docs) {
      Address tempAddress = Address.fromMap(tempData.data());

      address.add(tempAddress);
    }

    return address;
  }
}
