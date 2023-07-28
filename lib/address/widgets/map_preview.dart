import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPreview extends StatelessWidget {
  final Address selectedAddress;
  final Function(GoogleMapController)? onMapCreated;

  const MapPreview(
      {super.key, required this.selectedAddress, this.onMapCreated});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 130,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                selectedAddress.latitude,
                selectedAddress.longitude,
              ),
              zoom: 17,
            ),
            onMapCreated: onMapCreated ?? (GoogleMapController _) {},
            zoomGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
            zoomControlsEnabled: false,
          ),
          Center(
              child: Icon(
            Icons.location_on_rounded,
            color: scheme.primary,
            size: 40,
          )),
        ],
      ),
    );
  }
}
