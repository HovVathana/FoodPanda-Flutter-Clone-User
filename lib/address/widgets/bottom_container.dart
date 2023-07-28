// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:foodpanda_user/address/controllers/address_controller.dart';
import 'package:foodpanda_user/address/controllers/network_utils.dart';
import 'package:foodpanda_user/address/widgets/label_button.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:foodpanda_user/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class BottomContainer extends StatefulWidget {
  final Address address;
  final String? id;
  final TextEditingController houseNumberController;
  final TextEditingController streetController;
  final TextEditingController areaController;
  final TextEditingController floorController;
  final TextEditingController instructionController;
  final GoogleMapController? mapController;
  final bool? isSetLocation;
  final bool? isInstructionFocus;
  final Function(Address)? handleChange;

  const BottomContainer({
    Key? key,
    required this.address,
    this.id,
    required this.houseNumberController,
    required this.streetController,
    required this.areaController,
    required this.floorController,
    required this.instructionController,
    required this.mapController,
    this.isSetLocation,
    this.isInstructionFocus,
    this.handleChange,
  }) : super(key: key);

  @override
  State<BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer> {
  String label = '';
  bool isSearched = false;
  final AddressController addressController = AddressController();
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  List<Suggestion> searchSuggestion = [];
  Timer? searchOnStoppedTyping;

  onSubmit() async {
    Address address = Address(
      houseNumber: widget.houseNumberController.text.trim(),
      street: widget.streetController.text.trim(),
      area: widget.areaController.text.trim(),
      latitude: widget.address.latitude,
      longitude: widget.address.longitude,
      province: widget.address.province,
      floor: widget.floorController.text.trim(),
      deliveryInstruction: widget.instructionController.text,
      label: label,
    );
    String id = await addressController.saveAddressToFirestore(
        address: address, id: widget.id);
    Address newAddress = Address(
      id: id,
      houseNumber: address.houseNumber,
      street: address.street,
      area: address.area,
      latitude: address.latitude,
      longitude: address.longitude,
      province: address.province,
      floor: address.floor,
      deliveryInstruction: address.deliveryInstruction,
      label: address.label,
    );
    if (widget.isSetLocation != null && widget.isSetLocation == true) {
      final lp = context.read<LocationProvider>();

      await lp.selectAddress(newAddress);
    }
    if (widget.handleChange != null) {
      widget.handleChange!(newAddress);
    }
    Navigator.pop(context);
  }

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

  @override
  void initState() {
    if (widget.id != null) {
      setState(() {
        label = widget.address.label!;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isSearched
        ? DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.9,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isSearched = false;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: scheme.primary,
                            ),
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              child: TextField(
                                controller: searchController,
                                minLines: 1,
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
                                  hintText: 'Search for your exact address',
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                    bottom: 10,
                                    left: 15,
                                    right: 15,
                                  ),
                                  suffixIcon: searchText.isNotEmpty
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
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const Divider(),
                      searchSuggestion.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/foodpanda_location.png',
                                    width: 120,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    textAlign: TextAlign.center,
                                    'Enter an address to explore restaurants\naround you',
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchSuggestion.length,
                              itemBuilder: (context, index) {
                                final suggestion = searchSuggestion[index];
                                return GestureDetector(
                                  onTap: () async {
                                    LatLng latLng = await NetworkUtils()
                                        .getPlaceDetailFromId(
                                            suggestion.placeId);
                                    widget.mapController?.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: latLng, zoom: 17),
                                      ),
                                    );
                                    setState(() {
                                      isSearched = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                suggestion.mainText,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                suggestion.secondaryText
                                                    .split(', ')[0]
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                    ],
                  ),
                ),
              );
            },
          )
        : DraggableScrollableSheet(
            initialChildSize: widget.id != null ? 0.9 : 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [0.3, 0.9],
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: addNewAddress(scrollController),
              );
            },
          );
  }

  Container addNewAddress(ScrollController scrollController) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      child: Column(
        children: [
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[300],
            ),
            alignment: Alignment.center,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      'Add a new address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearched = true;
                            searchController.text =
                                '${widget.address.houseNumber.isEmpty && widget.address.street.isEmpty ? widget.address.province : ''}${widget.address.houseNumber.isNotEmpty ? widget.address.houseNumber + " " : ""}${widget.address.street}';
                            searchText =
                                '${widget.address.houseNumber.isEmpty && widget.address.street.isEmpty ? widget.address.province : ''}${widget.address.houseNumber.isNotEmpty ? widget.address.houseNumber + " " : ""}${widget.address.street}';
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: scheme.primary,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.address.houseNumber.isEmpty && widget.address.street.isEmpty ? widget.address.province : ''}${widget.address.houseNumber.isNotEmpty ? widget.address.houseNumber + " " : ""}${widget.address.street}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        widget.address.houseNumber.isEmpty &&
                                                widget.address.street.isEmpty
                                            ? const SizedBox()
                                            : Text(widget.address.province),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Icon(
                              Icons.edit_outlined,
                              color: scheme.primary,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(right: 7),
                          child: CustomTextField(
                            controller: widget.houseNumberController,
                            labelText: 'House Number',
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(left: 7),
                          child: CustomTextField(
                            controller: widget.streetController,
                            labelText: 'Street',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: widget.areaController,
                      labelText: 'Area',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: widget.floorController,
                      labelText: 'Floor/Unit #',
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Delivery instructions',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Please give us more information about your address',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: widget.instructionController,
                      labelText: 'Note to rider - e.g. landmark',
                      maxLength: 300,
                      isAutoFocus:
                          widget.isInstructionFocus == null ? false : true,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Add a label',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        LabelButton(
                          icon: Icons.home_outlined,
                          isSelected: label == 'Home',
                          title: 'Home',
                          onClick: () {
                            setState(() {
                              label = 'Home';
                            });
                          },
                        ),
                        const SizedBox(width: 35),
                        LabelButton(
                          icon: Icons.work_outline_rounded,
                          isSelected: label == 'Work',
                          title: 'Work',
                          onClick: () {
                            setState(() {
                              label = 'Work';
                            });
                          },
                        ),
                        const SizedBox(width: 35),
                        LabelButton(
                          icon: Icons.favorite_border_rounded,
                          isSelected: label == 'Partner',
                          title: 'Partner',
                          onClick: () {
                            setState(() {
                              label = 'Partner';
                            });
                          },
                        ),
                        const SizedBox(width: 35),
                        LabelButton(
                          icon: Icons.add,
                          isSelected: label == 'Other',
                          title: 'Other',
                          onClick: () {
                            setState(() {
                              label = 'Other';
                            });
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
          Divider(
            color: Colors.grey[300],
          ),
          CustomTextButton(
            text: widget.id != null ? 'Save and continue' : 'Continue',
            onPressed: onSubmit,
            isDisabled: false,
          ),
        ],
      ),
    );
  }
}
