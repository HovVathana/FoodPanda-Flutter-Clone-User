import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:foodpanda_user/authentication/screens/phone_number_register_screen.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/internet_provider.dart';
import 'package:foodpanda_user/widgets/custom_textfield.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class FillAccountInfo extends StatefulWidget {
  static const String routeName = '/fill-account-info-screen';

  final String email;

  const FillAccountInfo({super.key, required this.email});

  @override
  State<FillAccountInfo> createState() => _FillAccountInfoState();
}

class _FillAccountInfoState extends State<FillAccountInfo> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String firstNameText = '';
  String lastNameText = '';
  String passwordText = '';
  String errorText = '';
  bool isError = false;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
  }

  Future registerAccount() async {
    if (isError) {
      setState(() {
        errorText = 'Please complete the requirement.';
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
            .changePassword(
                widget.email,
                'password',
                passwordController.text.toString(),
                '${firstNameController.text.trim()} ${lastNameController.text.trim()} ')
            .then((value) async {
          if (authenticationProvider.hasError) {
            openSnackbar(
              context,
              authenticationProvider.errorCode,
              scheme.primary,
            );
            authenticationProvider.resetError();
          } else {
            await authenticationProvider.saveDataToFirestore().then(
                  (value) =>
                      authenticationProvider.saveDataToSharedPreferences().then(
                            (value) => authenticationProvider.setSignIn().then(
                              (value) async {
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
        });
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
            onPressed: firstNameText.isEmpty ||
                    lastNameText.isEmpty ||
                    passwordText.isEmpty
                ? null
                : registerAccount,
            child: Text(
              'Continue',
              style: TextStyle(
                color: firstNameText.isEmpty ||
                        lastNameText.isEmpty ||
                        passwordText.isEmpty
                    ? Colors.grey[400]
                    : scheme.primary,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20),
                      child: Image.asset(
                        'assets/images/profile_icon.png',
                        width: 60,
                      ),
                    ),
                    const Text(
                      'Let\'s get you started!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'First, let\'s create your foodpanda account with ${widget.email}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(right: 7),
                          child: CustomTextField(
                            controller: firstNameController,
                            labelText: 'First name',
                            onChanged: (value) {
                              setState(() {
                                firstNameText = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(left: 7),
                          child: CustomTextField(
                            controller: lastNameController,
                            labelText: 'Last name',
                            onChanged: (value) {
                              setState(() {
                                lastNameText = value;
                              });
                            },
                          ),
                        ),
                      ],
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
                    const SizedBox(
                      height: 20,
                    ),
                    FlutterPwValidator(
                      controller: passwordController,
                      minLength: 6,
                      uppercaseCharCount: 1,
                      lowercaseCharCount: 1,
                      numericCharCount: 1,
                      specialCharCount: 1,
                      width: 400,
                      defaultColor: Colors.grey[400]!,
                      failureColor: Colors.red,
                      height: 150,
                      onSuccess: () {
                        setState(() {
                          isError = false;
                        });
                      },
                      onFail: () {
                        setState(() {
                          isError = true;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Continue',
              onPressed: registerAccount,
              isDisabled: firstNameText.isEmpty ||
                  lastNameText.isEmpty ||
                  passwordText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
