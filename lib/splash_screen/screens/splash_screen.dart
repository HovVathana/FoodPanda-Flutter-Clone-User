import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/pick_location/screens/pick_location_screen.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLocation = false;

  Future getLocation() async {
    final locationProvider = context.read<LocationProvider>();
    await locationProvider.getAddressFromSharedPreference();
    if (locationProvider.latitude == null &&
        locationProvider.longitude == null) {
      isLocation = false;
    } else {
      isLocation = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    Timer(const Duration(seconds: 1), () {
      if (isLocation) {
        Navigator.pushReplacementNamed(
          context,
          HomeScreen.routeName,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          PickLocationScreen.routeName,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scheme.primary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash.png'),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
