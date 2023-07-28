import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/screens/email_authentication_screen.dart';
import 'package:foodpanda_user/authentication/screens/phone_number_register_screen.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/internet_provider.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

void showAuthenticationModal(BuildContext context) {
  Future handleGoogleSignIn() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();

    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      await authenticationProvider.signInWithGoogle(context).then(
        (value) {
          if (value) {
            authenticationProvider.checkUserExists().then(
              (value) async {
                if (value) {
// if user exist
                  await authenticationProvider
                      .getUserDataFromFirestore(authenticationProvider.uid)
                      .then(
                        (value) => authenticationProvider
                            .saveDataToSharedPreferences()
                            .then(
                              (value) =>
                                  authenticationProvider.setSignIn().then(
                                (value) async {
                                  await authenticationProvider
                                      .checkIfAccountHasPhoneNumber(
                                          authenticationProvider.uid)
                                      .then((value) {
                                    if (value == true) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);

                                      Navigator.pushNamed(
                                        context,
                                        PhoneNumberRegisterScreen.routeName,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                      );
                } else {
// user does not exist - new user
                  authenticationProvider.saveDataToFirestore().then(
                        (value) => authenticationProvider
                            .saveDataToSharedPreferences()
                            .then(
                              (value) =>
                                  authenticationProvider.setSignIn().then(
                                (value) {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    PhoneNumberRegisterScreen.routeName,
                                  );
                                },
                              ),
                            ),
                      );
                }
              },
            );
          }
        },
      );
    }
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (context) {
      return Container(
        height: 320,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        child: Column(
          children: [
            Container(
              height: 3,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
            ),
            const SizedBox(height: 15),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Sign up or Log in',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: handleGoogleSignIn,
              splashColor: Colors.grey[300],
              child: Ink(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Image.asset(
                        'assets/images/google_icon.webp',
                        width: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Continue with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                openSnackbar(context, 'message', scheme.primary);
              },
              splashColor: Colors.white70.withOpacity(0.1),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(59, 89, 152, 1),
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: double.infinity,
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Image.asset(
                        'assets/images/facebook_icon.png',
                        width: 30,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Continue with Facebook',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  color: Colors.grey[300],
                )),
                Text(
                  'or',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Expanded(
                    child: Divider(
                  color: Colors.grey[300],
                )),
              ],
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, EmailAuthenticationScreen.routeName);
              },
              splashColor: scheme.primary.withOpacity(0.05),
              child: Ink(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: scheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Continue with email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By continuing, you agree to our ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: Colors.teal[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Colors.teal[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                      text: '.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
