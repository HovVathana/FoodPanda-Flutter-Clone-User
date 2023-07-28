import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodpanda_user/cart/widgets/map_with_market_widget.dart';
import 'package:foodpanda_user/cart/widgets/order_screen_info.dart';
import 'package:foodpanda_user/models/order.dart';
import 'package:foodpanda_user/shop_details/widgets/ficon_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class OrderScreenWithMap extends StatefulWidget {
  final Order order;
  const OrderScreenWithMap({super.key, required this.order});

  @override
  State<OrderScreenWithMap> createState() => _OrderScreenWithMapState();
}

class _OrderScreenWithMapState extends State<OrderScreenWithMap> {
  GoogleMapController? mapController;

  BitmapDescriptor shopIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor riderIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void addCustomIcon() async {
    final Uint8List shopByte =
        await getBytesFromAsset('assets/images/location_shop_marker.png', 100);

    final Uint8List riderByte =
        await getBytesFromAsset('assets/images/location_rider_marker.png', 100);

    final Uint8List userByte =
        await getBytesFromAsset('assets/images/location_user_marker.png', 100);

    shopIcon = BitmapDescriptor.fromBytes(shopByte);
    riderIcon = BitmapDescriptor.fromBytes(riderByte);
    userIcon = BitmapDescriptor.fromBytes(userByte);

    setState(() {});
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: MapWithMarketWidget(
                      mapController: mapController,
                      latLng: LatLng(widget.order.address.latitude,
                          widget.order.address.longitude),
                      shopLatLng: LatLng(widget.order.shop.latitude,
                          widget.order.shop.longitude),
                      destination: widget.order.rider != null
                          ? LatLng(widget.order.rider!.latitude,
                              widget.order.rider!.longitude)
                          : LatLng(11, 104),
                      riderIcon: riderIcon,
                      shopIcon: shopIcon,
                      userIcon: userIcon,
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                          mapController = controller;
                        });
                      },
                      onCameraMove: (CameraPosition cp) {},
                      onCameraIdle: () {},
                      markerOnTap: () {},
                    )
                    // : const SizedBox(),
                    ),
                DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  snap: true,
                  snapSizes: const [0.3, 0.9],
                  builder: (context, scrollController) {
                    return ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: scrollController,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 3,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey[300],
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  OrderScreenInfo(
                                    order: widget.order,
                                  ),
                                  // const SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                        ));
                  },
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: FIconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
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
