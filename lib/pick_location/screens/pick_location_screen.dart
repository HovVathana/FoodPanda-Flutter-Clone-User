import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/pick_location/screens/search_address_manual_screen.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:provider/provider.dart';

class PickLocationScreen extends StatefulWidget {
  static const String routeName = 'pick-location-screen';
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  Future getLocation() async {
    final locationProvider = context.read<LocationProvider>();
    await locationProvider.getAddressFromSharedPreference();
    if (locationProvider.latitude == null &&
        locationProvider.longitude == null) {
    } else {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/foodpanda_cart.png',
                  width: 150,
                ),
                const SizedBox(height: 15),
                const Text(
                  textAlign: TextAlign.center,
                  'Find restaurants and shops near you!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  textAlign: TextAlign.center,
                  'By allowing location access, you can search for restaurants and shops near you and receive\nmore accurate delivery.',
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 0,
              offset: const Offset(0, -1),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            CustomTextButton(
              text: 'Share my current location',
              onPressed: () {
                getLocation();
              },
              isDisabled: false,
            ),
            CustomTextButton(
              text: 'Enter address manually',
              onPressed: () {
                Navigator.pushNamed(
                    context, SearchAddressManualScreen.routeName,
                    arguments: SearchAddressManualScreen(
                      getLocation: getLocation,
                    ));
              },
              isDisabled: false,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}
