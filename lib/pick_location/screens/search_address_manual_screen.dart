import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodpanda_user/address/controllers/network_utils.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SearchAddressManualScreen extends StatefulWidget {
  static const String routeName = '/search-address-manual-screen';
  final VoidCallback getLocation;
  const SearchAddressManualScreen({super.key, required this.getLocation});

  @override
  State<SearchAddressManualScreen> createState() =>
      _SearchAddressManualScreenState();
}

class _SearchAddressManualScreenState extends State<SearchAddressManualScreen> {
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;

  LatLng latLng = const LatLng(11.60012828429617, 104.92080923169853);
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  Timer? searchOnStoppedTyping;
  List<Suggestion> searchSuggestion = [];

  void placeAutoComplete(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchSuggestion = [];
      });
    } else {
      List<Suggestion> response = await NetworkUtils().fetchSuggestions(query);
      if (response.isNotEmpty) {
        setState(() {
          searchSuggestion = response;
        });
      } else {
        print(response);
      }
    }
  }

  void getPlaceDetail(placeId) async {
    LatLng latLng = await NetworkUtils().getPlaceDetailFromId(placeId);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 17),
      ),
    );

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (placemarks.length > 0) {
      searchSuggestion = [];

      print(placemarks[0]);
      String street = placemarks[0].thoroughfare != null
          ? placemarks[0].thoroughfare!.replaceAll('Saint', 'St.')
          : '';
      String province = placemarks[0].administrativeArea ?? '';

      searchController.text =
          street.isNotEmpty ? '$street, $province' : province;
      searchText = street.isNotEmpty ? '$street, $province' : province;
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {});
    }
  }

  void onSubmit() async {
    final lp = context.read<LocationProvider>();
    LatLng selectLatLng = cameraPosition == null
        ? latLng
        : LatLng(
            cameraPosition!.target.latitude, cameraPosition!.target.longitude);
    await lp.setLocationManually(selectLatLng);
    await lp.getPlacemarks();
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        elevation: 0.5,
        title: Container(
          alignment: Alignment.center,
          height: 40,
          child: TextField(
            controller: searchController,
            minLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
              const duration = Duration(milliseconds: 1000);
              if (searchOnStoppedTyping != null) {
                setState(
                  () => searchOnStoppedTyping!.cancel(),
                ); // clear timer
              }
              setState(
                () => searchOnStoppedTyping = Timer(
                  duration,
                  () => placeAutoComplete(value),
                ),
              );
            },
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              fillColor: Colors.grey[100],
              hintText: 'Set delivery address',
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              contentPadding: const EdgeInsets.only(
                bottom: 10,
                left: 15,
                right: 15,
              ),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  searchText.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              searchController.text = '';
                              searchText = '';
                            });
                          },
                          child: Icon(
                            Icons.highlight_remove_rounded,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: widget.getLocation,
                    child: Icon(
                      Icons.gps_fixed_outlined,
                      color: scheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: latLng,
              zoom: 7,
            ),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cp) {
              setState(() {
                cameraPosition = cp;
              });
            },
            onCameraIdle: () {},
            compassEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
          ),
          Center(
            child: Icon(
              Icons.location_on_rounded,
              color: scheme.primary,
              size: 40,
            ),
          ),
          searchSuggestion.isEmpty
              ? const SizedBox()
              : Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.29,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchSuggestion.length < 5
                          ? searchSuggestion.length
                          : 5,
                      itemBuilder: (context, index) {
                        final suggestion = searchSuggestion[index];
                        return GestureDetector(
                          onTap: () => getPlaceDetail(suggestion.placeId),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    '${suggestion.mainText}, ${suggestion.secondaryText.replaceAll(', Cambodia', '')}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )),
          Positioned(
            right: 0,
            left: 0,
            bottom: 30,
            child: CustomTextButton(
              text: 'Confirm',
              onPressed: onSubmit,
              isDisabled: false,
            ),
          ),
        ],
      ),
    );
  }
}
