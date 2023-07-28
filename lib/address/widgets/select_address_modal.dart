import 'package:flutter/material.dart';
import 'package:foodpanda_user/address/screens/edit_address_screen.dart';
import 'package:foodpanda_user/address/widgets/map_preview.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:provider/provider.dart';

void showSelectAddressModal(BuildContext context, List<Address> addressList) {
  final lp = context.read<LocationProvider>();
  Address selectedAddress = lp.address!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                height: 3,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[300],
                ),
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              // Container(
                              //   height: 3,
                              //   width: 50,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(50),
                              //     color: Colors.grey[300],
                              //   ),
                              //   alignment: Alignment.center,
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    await lp.getCurrentLocation();
                                    await lp.getPlacemarks();
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.near_me_sharp,
                                        color: scheme.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Use my current location',
                                        style: TextStyle(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              StatefulBuilder(builder: (BuildContext context,
                                  StateSetter setModalState) {
                                return Column(
                                  children: [
                                    selectedAddress == lp.address
                                        ? Container(
                                            width: double.infinity,
                                            color: scheme.primary
                                                .withOpacity(0.05),
                                            padding: const EdgeInsets.all(10),
                                            child: MapPreview(
                                                selectedAddress:
                                                    selectedAddress))
                                        : const SizedBox(),
                                    RadioListTile(
                                      value: lp.address,
                                      groupValue: selectedAddress,
                                      onChanged: (val) async {
                                        setModalState(() {
                                          selectedAddress = val!;
                                        });
                                        // await lp.selectAddress(selectedAddress);
                                        Navigator.pop(context);
                                      },
                                      secondary: !lp.isCurrentLocation
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    EditAddressScreen.routeName,
                                                    arguments:
                                                        EditAddressScreen(
                                                      editAddress: lp.address,
                                                    ));
                                              },
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: scheme.primary,
                                              ),
                                            )
                                          : const SizedBox(),
                                      activeColor: scheme.primary,
                                      selected: selectedAddress == lp.address,
                                      selectedTileColor:
                                          scheme.primary.withOpacity(0.05),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lp.isCurrentLocation
                                                ? 'Current Location'
                                                : lp.address!.label!.isNotEmpty
                                                    ? lp.address!.label!
                                                    : '${lp.address!.houseNumber.isEmpty ? '' : lp.address!.houseNumber + ' '}${lp.address!.street}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          lp.address!.label!.isNotEmpty ||
                                                  lp.isCurrentLocation
                                              ? Text(
                                                  '${lp.address!.houseNumber.isEmpty ? '' : lp.address!.houseNumber + ' '}${lp.address!.street}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Text(
                                            lp.address!.province,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: addressList.length,
                                        itemBuilder: (context, index) {
                                          final address = addressList[index];

                                          return Column(
                                            children: [
                                              selectedAddress == address
                                                  ? Container(
                                                      width: double.infinity,
                                                      color: scheme.primary
                                                          .withOpacity(0.05),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: MapPreview(
                                                          selectedAddress:
                                                              selectedAddress),
                                                    )
                                                  : const SizedBox(),
                                              RadioListTile(
                                                value: address,
                                                groupValue: selectedAddress,
                                                onChanged: (val) async {
                                                  setModalState(() {
                                                    selectedAddress = val!;
                                                  });
                                                  await lp.selectAddress(
                                                      selectedAddress);
                                                  Navigator.pop(context);
                                                },
                                                secondary: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        EditAddressScreen
                                                            .routeName,
                                                        arguments:
                                                            EditAddressScreen(
                                                          editAddress: address,
                                                        ));
                                                  },
                                                  child: Icon(
                                                    Icons.edit_outlined,
                                                    color: scheme.primary,
                                                  ),
                                                ),
                                                activeColor: scheme.primary,
                                                selected:
                                                    selectedAddress == address,
                                                selectedTileColor: scheme
                                                    .primary
                                                    .withOpacity(0.05),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      address.label!.isNotEmpty
                                                          ? address.label!
                                                          : '${address.houseNumber.isEmpty ? '' : address.houseNumber + ' '}${address.street}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    address.label!.isNotEmpty
                                                        ? Text(
                                                            '${address.houseNumber.isEmpty ? '' : address.houseNumber + ' '}${address.street}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
                                                              fontSize: 14,
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    Text(
                                                      address.province,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, EditAddressScreen.routeName,
                                arguments: const EditAddressScreen(
                                  editAddress: null,
                                  isSetLocation: true,
                                ));
                          },
                          child: Ink(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: scheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Add New Address',
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
