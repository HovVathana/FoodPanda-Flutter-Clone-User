import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/screens/phone_number_register_screen.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/internet_provider.dart';
import 'package:foodpanda_user/widgets/custom_textfield.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class LoginWithEmailScreen extends StatefulWidget {
  static const String routeName = '/login-with-email-screen';

  final String? email;

  const LoginWithEmailScreen({super.key, required this.email});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  TextEditingController passwordController = TextEditingController();
  bool isFocus = false;
  bool isObscure = false;
  String passwordText = '';
  String errorText = '';

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }

  handleEmailSignIn() async {
    if (passwordController.text.length < 4) {
      setState(() {
        errorText = 'Password has to be at least 4 characters long';
      });
    } else {
      setState(() {
        errorText = '';
      });
    }

    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      if (errorText.isEmpty) {
        await authenticationProvider
            .signInWithEmailAndPassword(
          context: context,
          email: widget.email,
          password: passwordController.text,
        )
            .then(
          (value) async {
// if user exist
            if (authenticationProvider.hasError) {
              openSnackbar(
                context,
                authenticationProvider.errorCode,
                scheme.primary,
              );
              authenticationProvider.resetError();
            } else {
              await authenticationProvider
                  .getUserDataFromFirestore(authenticationProvider.uid)
                  .then(
                    (value) => authenticationProvider
                        .saveDataToSharedPreferences()
                        .then(
                          (value) => authenticationProvider.setSignIn().then(
                            (value) async {
                              // NotificationHelper().saveToken();
                              await authenticationProvider
                                  .checkIfAccountHasPhoneNumber(
                                      authenticationProvider.uid)
                                  .then((value) {
                                if (value == true) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    HomeScreen.routeName,
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    HomeScreen.routeName,
                                    (route) => false,
                                  );
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
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        actions: [
          TextButton(
            onPressed: passwordText.isEmpty ? null : handleEmailSignIn,
            child: Text(
              'Continue',
              style: TextStyle(
                color: passwordText.isEmpty ? Colors.grey[400] : scheme.primary,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 20),
                    child: Image.asset(
                      'assets/images/login_icon.png',
                      width: 60,
                    ),
                  ),
                  const Text(
                    'Log in with your email',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    controller: null,
                    labelText: 'Email',
                    initialValue: widget.email,
                    isDisabled: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    noIcon: false,
                    onChanged: (value) {
                      setState(() {
                        passwordText = value;
                      });
                    },
                    errorText: errorText,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'I forgot my password',
                      style: TextStyle(
                        color: scheme.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Continue',
              onPressed: handleEmailSignIn,
              isDisabled: passwordText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
