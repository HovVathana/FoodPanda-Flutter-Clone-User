import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:foodpanda_user/authentication/screens/phone_otp_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  AuthenticationProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void resetError() async {
    _hasError = false;
    _errorCode = null;
    notifyListeners();
  }

  Future signInWithGoogle(context) async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // sign in to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // save all values
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = 'GOOGLE';
        _uid = userDetails.uid;
        notifyListeners();
        return true;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            _errorCode =
                'You already have an account with us. Use the correct provider';
            _hasError = true;
            notifyListeners();

            break;

          case 'null':
            _errorCode = 'Some unexpected error while trying to sign in';
            _hasError = true;
            notifyListeners();

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      return false;
      // _hasError = true;
      // notifyListeners();
    }
  }

  Future getUserDataFromFirestore(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _provider = snapshot['provider'],
              _imageUrl = snapshot['image_url'],
              _phoneNumber = snapshot.data().toString().contains('phoneNumber')
                  ? snapshot['phoneNumber']
                  : '',
            });

    notifyListeners();
  }

  Future saveDataToFirestore() async {
    final DocumentReference reference =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    await reference.set(
      {
        "name": _name,
        "email": _email,
        "uid": _uid,
        "image_url": _imageUrl,
        "provider": _provider,
        "phoneNumber": _phoneNumber,
      },
    );
    notifyListeners();
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', _name!);
    await sharedPreferences.setString('email', _email!);
    await sharedPreferences.setString('uid', _uid!);
    await sharedPreferences.setString('image_url', _imageUrl!);
    await sharedPreferences.setString('provider', _provider!);
    await sharedPreferences.setString('phoneNumber', _phoneNumber ?? '');
    notifyListeners();
  }

  Future getUserDataFromSharedPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _name = sharedPreferences.getString('name');
    _email = sharedPreferences.getString('email');
    _uid = sharedPreferences.getString('uid');
    _imageUrl = sharedPreferences.getString('image_url');
    _provider = sharedPreferences.getString('provider');
    _phoneNumber = sharedPreferences.getString('phoneNumber');
    notifyListeners();
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  Future<bool> isEmailExist(email) async {
    List<String> emails = await firebaseAuth.fetchSignInMethodsForEmail(email);

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // if the account is in the firebase auth and not the firestore - user login but not yet finished
    if (emails.isNotEmpty && emails[0] == 'password' && query.docs.isEmpty) {
      return false;
    } else if (emails.isEmpty && query.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future registerWithEmail(email, password) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (result) async {
          //send verifcation email
          result.user!.sendEmailVerification();
          return result.user;
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future resendEmail(email, password) async {
    final userDetails = (await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    await userDetails!.sendEmailVerification();
  }

  Future changePassword(email, currentPassword, newPassword, name) async {
    try {
      final userDetails = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: currentPassword))
          .user;

      await userDetails!.updatePassword(newPassword).then((_) {
        if (userDetails.emailVerified) {
          _name = userDetails.displayName ?? name;
          _email = userDetails.email;
          _imageUrl = userDetails.photoURL ?? '';
          _provider = 'EMAIL';
          _uid = userDetails.uid;

          notifyListeners();
        }
      });
    } catch (error) {
      _errorCode = 'Something went wrong.';
      _hasError = true;
      notifyListeners();
    }
  }

  Future signInWithEmailAndPassword({
    required context,
    required email,
    required password,
  }) async {
    try {
      final userDetails = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      _name = userDetails.displayName;
      _email = userDetails.email;
      _imageUrl = userDetails.photoURL;
      _provider = 'EMAIL';
      _uid = userDetails.uid;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          _errorCode =
              'You already have an account with us. Use the correct provider';
          _hasError = true;
          notifyListeners();

          break;

        case 'wrong-password':
          _errorCode = 'Username or password is incorrect';
          _hasError = true;
          notifyListeners();

          break;

        case 'null':
          _errorCode = 'Some unexpected error while trying to sign in';
          _hasError = true;
          notifyListeners();
          break;

        default:
          _errorCode = 'Failed with error code: ${e.code}';
          _hasError = true;
          notifyListeners();
          break;
      }
    }
  }

  Future<bool> checkIfAccountHasPhoneNumber(uid) async {
    try {
      bool isExist = false;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userData.get('phoneNumber').length > 0) {
        isExist = true;
      }
      return isExist;
    } catch (e) {
      // _errorCode = e.toString();
      // _hasError = true;
      // notifyListeners();
      return false;
    }
  }

  Future checkIfPhoneNumberExist(phoneNumber) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (query.docs.isEmpty) {
        return false;
      } else {
        _errorCode =
            'Your phone number is already registed. Please login to your account.';
        _hasError = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  Future signInWithPhone(context, String phoneNumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.pushNamed(context, PhoneOTPScreen.routeName, arguments: {
            'verificationId': verificationId,
            'phoneNumber': phoneNumber,
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      _errorCode = e.message.toString();
      _hasError = true;
      notifyListeners();
    }
  }

  Future verifyPhoneOTP({
    required String verificationId,
    required String userOTP,
    required Function onSuccess,
  }) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      User? user = (await firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      _errorCode = e.message.toString();
      _hasError = true;
      notifyListeners();
    }
  }

  Future addPhoneNumberToFirestore(String number) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await FirebaseFirestore.instance.collection('users').doc(_uid).set(
        {
          "phoneNumber": number,
        },
        SetOptions(merge: true),
      );
      _phoneNumber = number;
      notifyListeners();
      await sharedPreferences.setString('phoneNumber', _phoneNumber!);
    } catch (error) {
      _errorCode = error.toString();
      _hasError = true;
      notifyListeners();
    }
  }
}
