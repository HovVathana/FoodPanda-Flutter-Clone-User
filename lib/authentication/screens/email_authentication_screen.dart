import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodpanda_user/authentication/screens/login_with_email_screen.dart';
import 'package:foodpanda_user/authentication/screens/send_verification_email_screen.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/internet_provider.dart';
import 'package:foodpanda_user/widgets/custom_textfield.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class EmailAuthenticationScreen extends StatefulWidget {
  static const String routeName = '/email-authentication-screen';

  const EmailAuthenticationScreen({super.key});

  @override
  State<EmailAuthenticationScreen> createState() =>
      _EmailAuthenticationScreenState();
}

class _EmailAuthenticationScreenState extends State<EmailAuthenticationScreen> {
  TextEditingController emailController = TextEditingController();
  bool isFocus = false;
  String emailText = '';
  String errorText = '';

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  handleEmailSignIn() async {
    errorText = validateEmail(emailController.text.trim().toString())!;
    setState(() {});

    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      if (errorText.isEmpty) {
        bool isEmailExist = await authenticationProvider
            .isEmailExist(emailController.text.trim().toString());
        if (isEmailExist) {
          Navigator.pushNamed(
            context,
            LoginWithEmailScreen.routeName,
            arguments: emailController.text.trim().toString(),
          );
        } else {
          Navigator.pushNamed(
            context,
            SendVerificationEmailScreen.routeName,
            arguments: emailController.text.trim().toString(),
          );
        }
      }
    }
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        actions: [
          TextButton(
            onPressed: emailText.isEmpty ? null : handleEmailSignIn,
            child: Text(
              'Continue',
              style: TextStyle(
                color: emailText.isEmpty ? Colors.grey[400] : scheme.primary,
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
                      'assets/images/email_icon.png',
                      width: 60,
                    ),
                  ),
                  const Text(
                    'What\'s your email?',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We\'ll check if you have an account',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                    onChanged: (value) {
                      setState(() {
                        emailText = value;
                      });
                    },
                    errorText: errorText,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Continue',
              onPressed: handleEmailSignIn,
              isDisabled: emailText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
