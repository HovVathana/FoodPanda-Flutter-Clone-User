import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/internet_provider.dart';
import 'package:foodpanda_user/widgets/custom_textfield.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class PhoneNumberRegisterScreen extends StatefulWidget {
  static const String routeName = '/phone-number-register-screen';

  const PhoneNumberRegisterScreen({super.key});

  @override
  State<PhoneNumberRegisterScreen> createState() =>
      _PhoneNumberRegisterScreenState();
}

class _PhoneNumberRegisterScreenState extends State<PhoneNumberRegisterScreen> {
  TextEditingController phoneNumberController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: '855',
    countryCode: 'KH',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Cambodia',
    example: 'Cambodia',
    displayName: 'Cambodia',
    displayNameNoCountryCode: 'KH',
    e164Key: '',
  );

  String phoneNumberText = '';

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
  }

  Future registerPhoneNumber() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      String phoneNumber =
          '+${selectedCountry.phoneCode}${phoneNumberController.text}';
      bool isExist = await authenticationProvider.checkIfPhoneNumberExist(
        phoneNumber,
      );
      if (authenticationProvider.hasError) {
        openSnackbar(
          context,
          authenticationProvider.errorCode,
          scheme.primary,
        );
        authenticationProvider.resetError();
      } else {
        if (!isExist) {
          await authenticationProvider.signInWithPhone(context, phoneNumber);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        actions: [
          TextButton(
            onPressed: phoneNumberText.isEmpty ? null : registerPhoneNumber,
            child: Text(
              'Continue',
              style: TextStyle(
                color:
                    phoneNumberText.isEmpty ? Colors.grey[400] : scheme.primary,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 20),
                    child: Image.asset(
                      'assets/images/mobile_icon.png',
                      width: 60,
                    ),
                  ),
                  const Text(
                    'What\'s your mobile number?',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We need this to verify and secure your account',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              countryListTheme: CountryListThemeData(
                                flagSize: 25,
                                backgroundColor: Colors.white,
                                textStyle: const TextStyle(
                                    fontSize: 16, color: Colors.blueGrey),
                                bottomSheetHeight: 500,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                //Optional. Styles the search field.
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountry = country;
                                });
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400]!,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${selectedCountry.flagEmoji}  +${selectedCountry.phoneCode}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomTextField(
                          controller: phoneNumberController,
                          labelText: 'Mobile Number',
                          onChanged: (value) {
                            setState(() {
                              phoneNumberText = value;
                            });
                          },
                          isNumPad: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
                text: 'Continue',
                onPressed: registerPhoneNumber,
                isDisabled: phoneNumberText.isEmpty),
          ],
        ),
      ),
    );
  }
}
