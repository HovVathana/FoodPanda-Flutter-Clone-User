import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithMarketWidget extends StatelessWidget {
  final LatLng latLng;
  final LatLng destination;
  final LatLng shopLatLng;
  // final List<LatLng> polylineCoordinates;
  final Function(CameraPosition) onCameraMove;
  final VoidCallback onCameraIdle;
  final VoidCallback markerOnTap;
  final GoogleMapController? mapController;
  final Function(GoogleMapController) onMapCreated;
  final BitmapDescriptor riderIcon;
  final BitmapDescriptor shopIcon;
  final BitmapDescriptor userIcon;

  MapWithMarketWidget({
    Key? key,
    required this.latLng,
    required this.onCameraMove,
    required this.onCameraIdle,
    required this.mapController,
    required this.onMapCreated,
    required this.destination,
    // required this.polylineCoordinates,
    required this.markerOnTap,
    required this.shopLatLng,
    required this.riderIcon,
    required this.shopIcon,
    required this.userIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: MarkerId("shop"),
          position: shopLatLng,
          icon: shopIcon,
        ),
        Marker(
          markerId: MarkerId("rider"),
          position: destination,
          icon: riderIcon,

          // onTap: markerOnTap,
        ),
        Marker(
          markerId: MarkerId("source"),
          icon: userIcon,
          position: latLng,

          // onTap: markerOnTap,
        ),
      },
      compassEnabled: false,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      buildingsEnabled: true,
      onMapCreated: onMapCreated,
      onCameraMove: onCameraMove,
      onCameraIdle: onCameraIdle,
    );
  }
}
