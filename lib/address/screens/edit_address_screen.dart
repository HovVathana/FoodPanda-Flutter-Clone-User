// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:foodpanda_user/address/controllers/address_controller.dart';
import 'package:foodpanda_user/address/widgets/bottom_container.dart';
import 'package:foodpanda_user/address/widgets/map_widget.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:foodpanda_user/shop_details/widgets/ficon_button.dart';

class EditAddressScreen extends StatefulWidget {
  static const String routeName = '/edit-address-screen';
  final Address? editAddress;
  final bool? isSetLocation;
  final bool? isInstructionFocus;
  final Function(Address)? handleChange;

  const EditAddressScreen({
    Key? key,
    this.editAddress,
    this.isSetLocation,
    this.isInstructionFocus,
    this.handleChange,
  }) : super(key: key);

  @override
  State<EditAddressScreen> createState() => EditAddressScreenState();
}

class EditAddressScreenState extends State<EditAddressScreen> {
  final AddressController addressController = AddressController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();

  GoogleMapController? mapController;

  LatLng? latLng;
  CameraPosition? cameraPosition;
  Address? address;
  bool firstLoad = true;

  @override
  void dispose() {
    super.dispose();
    houseNumberController.dispose();
    streetController.dispose();
    areaController.dispose();
    floorController.dispose();
    instructionController.dispose();
  }

  Future getLocation() async {
    final locationProvider = context.read<LocationProvider>();
    if (locationProvider.latitude != null &&
        locationProvider.longitude != null) {
      latLng = LatLng(locationProvider.latitude!, locationProvider.longitude!);
    } else {
      latLng = const LatLng(11, 104);
    }
    cameraPosition = CameraPosition(target: latLng!);
    await getPlacemarks();
    setState(() {});
  }

  Future getPlacemarks() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        cameraPosition!.target.latitude, cameraPosition!.target.longitude);

    if (placemarks.length > 0) {
      address = Address(
        houseNumber: placemarks[0].subThoroughfare ?? '',
        street: placemarks[0].thoroughfare != null
            ? placemarks[0].thoroughfare!.replaceAll('Saint', 'St.')
            : '',
        area: placemarks[0].subLocality ?? '',
        province: placemarks[0].administrativeArea ?? '',
        latitude: cameraPosition!.target.latitude,
        longitude: cameraPosition!.target.longitude,
        floor: '',
        deliveryInstruction: '',
        label: '',
      );

      houseNumberController.text = address!.houseNumber;
      streetController.text = address!.street;
      areaController.text = address!.area;
    }

    setState(() {});
  }

  Future setLocation() async {
    latLng =
        LatLng(widget.editAddress!.latitude, widget.editAddress!.longitude);
    cameraPosition = CameraPosition(target: latLng!);
    // await getPlacemarks();
    address = widget.editAddress!;
    houseNumberController.text = address!.houseNumber;
    streetController.text = address!.street;
    areaController.text = address!.area;
    floorController.text = address!.floor;
    instructionController.text = address!.deliveryInstruction!;

    setState(() {});
  }

  @override
  void initState() {
    if (widget.editAddress == null) {
      getLocation();
    } else {
      setLocation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(mapController != null ? 'yes have' : 'no have');
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.678,
                  width: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      latLng != null && cameraPosition != null
                          ? MapWidget(
                              mapController: mapController,
                              latLng: latLng!,
                              onMapCreated: (GoogleMapController controller) {
                                setState(() {
                                  mapController = controller;
                                });
                              },
                              onCameraMove: (CameraPosition cp) {
                                firstLoad = false;
                                setState(() {
                                  cameraPosition = cp;
                                });
                              },
                              onCameraIdle: firstLoad ? () {} : getPlacemarks,
                            )
                          : const SizedBox(),
                      Center(
                          child: Icon(
                        Icons.location_on_rounded,
                        color: scheme.primary,
                        size: 40,
                      )),
                    ],
                  ),
                ),
                address != null
                    ? BottomContainer(
                        address: address!,
                        id: widget.editAddress == null
                            ? null
                            : widget.editAddress!.id,
                        houseNumberController: houseNumberController,
                        streetController: streetController,
                        areaController: areaController,
                        floorController: floorController,
                        instructionController: instructionController,
                        mapController: mapController,
                        isSetLocation: widget.isSetLocation,
                        isInstructionFocus: widget.isInstructionFocus,
                        handleChange: widget.handleChange,
                      )
                    : const SizedBox(),
                Positioned(
                  top: 20,
                  left: 10,
                  child: FIconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async {
                      //  ongoing flutter issue regarding leaving the screen with map too quickly
                      // await Future.delayed(const Duration(seconds: 2));
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
