import 'package:flutter/material.dart';
import 'package:foodpanda_user/address/controllers/address_controller.dart';
import 'package:foodpanda_user/address/screens/edit_address_screen.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address-screen';
  final Address? selectedAddress;
  final Function(Address)? handleChange;
  final GoogleMapController? mapController;
  const AddressScreen(
      {super.key, this.selectedAddress, this.handleChange, this.mapController});

  @override
  State<AddressScreen> createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen> {
  final AddressController addressController = AddressController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        title: const Text(
          'Addresses',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        elevation: 0.5,
      ),
      body: StreamBuilder<List<Address>>(
        stream: addressController.fetchAddress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading');
          }
          return snapshot.data!.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/foodpanda_location.png',
                        width: 150,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        textAlign: TextAlign.center,
                        'It\'s empty here',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        textAlign: TextAlign.center,
                        'You haven\'t saved any address yet. Add New\nAddress to get started',
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, EditAddressScreen.routeName,
                              arguments: const EditAddressScreen(
                                editAddress: null,
                              ));
                        },
                        splashColor: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Add New Address',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final address = snapshot.data![index];

                          return GestureDetector(
                            onTap: () {
                              if (widget.handleChange != null) {
                                widget.handleChange!(address);
                                widget.mapController?.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        target: LatLng(address.latitude,
                                            address.longitude),
                                        zoom: 17),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                Navigator.pushNamed(
                                    context, EditAddressScreen.routeName,
                                    arguments: EditAddressScreen(
                                      editAddress: address,
                                    ));
                              }
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widget.selectedAddress == null
                                          ? Icon(
                                              address.label!.isNotEmpty
                                                  ? address.label == 'Home'
                                                      ? Icons.home_outlined
                                                      : address.label == 'Work'
                                                          ? Icons
                                                              .work_outline_rounded
                                                          : address.label ==
                                                                  'Partner'
                                                              ? Icons
                                                                  .favorite_border_rounded
                                                              : address.label ==
                                                                      'Other'
                                                                  ? Icons.add
                                                                  : Icons
                                                                      .location_on_outlined
                                                  : Icons.location_on_outlined,
                                              color: scheme.primary,
                                              size: 30,
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Icon(
                                                widget.selectedAddress!.id ==
                                                        address.id
                                                    ? Icons.radio_button_checked
                                                    : Icons.radio_button_off,
                                                color: scheme.primary,
                                              ),
                                            ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            address.label!.isNotEmpty
                                                ? Text(
                                                    address.label!,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            address.label!.isNotEmpty
                                                ? const SizedBox(height: 5)
                                                : const SizedBox(),
                                            Text(
                                              '${address.houseNumber.isEmpty ? '' : address.houseNumber + ' '}${address.street}',
                                              style: TextStyle(
                                                fontWeight:
                                                    address.label!.isNotEmpty
                                                        ? FontWeight.normal
                                                        : FontWeight.w700,
                                                color: address.label!.isNotEmpty
                                                    ? Colors.grey[600]
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              address.province,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Note to rider: ${address.deliveryInstruction!.isEmpty ? 'none' : address.deliveryInstruction}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              EditAddressScreen.routeName,
                                              arguments: EditAddressScreen(
                                                editAddress: address,
                                                handleChange:
                                                    widget.handleChange,
                                              ));
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          color: scheme.primary,
                                          size: 30,
                                        ),
                                      ),
                                      widget.selectedAddress == null
                                          ? GestureDetector(
                                              onTap: () async {
                                                await addressController
                                                    .deleteAddress(
                                                        id: address.id!);
                                              },
                                              child: Icon(
                                                Icons.delete_outline_rounded,
                                                color: scheme.primary,
                                                size: 30,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: MyColors.backgroundColor,
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
                      child: CustomTextButton(
                        text: 'Add New Address',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EditAddressScreen.routeName,
                              arguments: const EditAddressScreen(
                                editAddress: null,
                              ));
                        },
                        isDisabled: false,
                      ),
                    ),
                  ],
                );
        },
      ),
      // bottomNavigationBar:
    );
  }
}
