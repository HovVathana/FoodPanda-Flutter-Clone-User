import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final LatLng latLng;
  final Function(CameraPosition) onCameraMove;
  final VoidCallback onCameraIdle;
  final GoogleMapController? mapController;
  final Function(GoogleMapController) onMapCreated;

  MapWidget({
    Key? key,
    required this.latLng,
    required this.onCameraMove,
    required this.onCameraIdle,
    required this.mapController,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: 17,
      ),
      minMaxZoomPreference: MinMaxZoomPreference(0, 16),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      compassEnabled: false,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      onMapCreated: onMapCreated,
      onCameraMove: onCameraMove,
      onCameraIdle: onCameraIdle,
    );
  }
}
