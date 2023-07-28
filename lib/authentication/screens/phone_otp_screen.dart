import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/internet_provider.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PhoneOTPScreen extends StatefulWidget {
  static const String routeName = '/phone-otp-screen';

  final String verificationId;
  final String phoneNumber;

  const PhoneOTPScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<PhoneOTPScreen> createState() => _PhoneOTPScreenState();
}

class _PhoneOTPScreenState extends State<PhoneOTPScreen> {
  String otpCode = '';
  int seconds = 60;
  late Timer _timer;
  bool isBtnDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          isBtnDisabled = false;
          _timer.cancel();
        }
      });
    });
  }

  Future verifyOTP() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      if (authenticationProvider.hasError) {
        openSnackbar(
          context,
          authenticationProvider.errorCode,
          scheme.primary,
        );
        authenticationProvider.resetError();
      } else {
        await authenticationProvider.verifyPhoneOTP(
          verificationId: widget.verificationId,
          userOTP: otpCode,
          onSuccess: () async {
            await authenticationProvider
                .addPhoneNumberToFirestore(widget.phoneNumber);
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        );
      }
    }
  }

  Future resendOTP() async {
    final authenticationProvider = context.read<AuthenticationProvider>();

    await authenticationProvider.signInWithPhone(context, widget.phoneNumber);
    setState(() {
      seconds = 60;
      isBtnDisabled = false;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 20),
                  child: Image.asset(
                    'assets/images/otp_icon.png',
                    width: 60,
                  ),
                ),
                const Text(
                  'Verify your mobile number',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter 4-digit code sent to your mobile number',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      otpCode = value;
                    });
                    if (otpCode.length == 6) {
                      verifyOTP();
                    }
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CustomTextButton(
                    text: 'Send code again',
                    onPressed: resendOTP,
                    isDisabled: isBtnDisabled,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Try again in $seconds seconds'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
