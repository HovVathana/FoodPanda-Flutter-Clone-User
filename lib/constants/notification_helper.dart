// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationHelper {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<String> getToken() async {
//     await FirebaseMessaging.instance.getToken().then((token) {
//       return token;
//     });
//     return '';
//   }

//   void saveToken() async {
//     String token = await getToken();
//     await firestore
//         .collection('tokens')
//         .doc(firebaseAuth.currentUser!.uid)
//         .set({
//       'token': token,
//     });
//   }

//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

// // Future<void> sendNotification(
// //   tokens,
// //   String title,
// //   String body,
// //   String imageUrl,
// // ) async {
// //   FirebaseFunctions functions =
// //       FirebaseFunctions.instanceFor(region: 'us-central1');

// //   try {
// //     final HttpsCallable callable = functions.httpsCallable('sendNotification');
// //     final response = await callable.call({
// //       'tokens': tokens,
// //       'title': title,
// //       'body': body,
// //       'imageUrl': imageUrl,
// //     });

// //     print('Message sent: ${response.data}');
// //   } catch (e) {
// //     print('Error sending message: $e');
// //   }
// // }
// }
