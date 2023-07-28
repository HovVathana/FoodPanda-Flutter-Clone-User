import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_widgets/flutter_sticky_widgets.dart';
import 'package:foodpanda_user/address/screens/address_screen.dart';
import 'package:foodpanda_user/address/screens/edit_address_screen.dart';
import 'package:foodpanda_user/address/widgets/map_preview.dart';
import 'package:foodpanda_user/cart/screens/order_screen.dart';
import 'package:foodpanda_user/cart/widgets/bottom_navigation.dart';
import 'package:foodpanda_user/cart/widgets/box_container.dart';
import 'package:foodpanda_user/cart/widgets/progress_stepper.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/constants/helper.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:foodpanda_user/models/cart.dart';
import 'package:foodpanda_user/models/order.dart';
import 'package:foodpanda_user/models/user.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/cart_provider.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:foodpanda_user/providers/order_provider.dart';
import 'package:foodpanda_user/voucher/controllers/voucher_controller.dart';
import 'package:foodpanda_user/widgets/my_snack_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout-screen';

  final List<Cart> carts;
  final double subtotalPrice;
  final double deliveryPrice;
  final double discountPrice;
  final bool isCutlery;
  final String? voucherId;

  const CheckoutScreen({
    super.key,
    required this.carts,
    required this.subtotalPrice,
    required this.deliveryPrice,
    required this.isCutlery,
    required this.discountPrice,
    this.voucherId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isProgess = true;

  ScrollController scrollController = ScrollController();
  GoogleMapController? mapController;

  late Address selectedAddress;
  double deliveryPrice = 0;

  @override
  void initState() {
    final lp = context.read<LocationProvider>();
    setState(() {
      deliveryPrice = widget.deliveryPrice;
      selectedAddress = lp.address!;
    });
    scrollController.addListener(() {
      if (scrollController.offset > 43.262162642045496) {
        setState(() {
          isProgess = false;
        });
      } else {
        setState(() {
          isProgess = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  placeOrder() async {
    final ap = context.read<AuthenticationProvider>();
    final op = context.read<OrderProvider>();
    VoucherController voucherController = VoucherController();

    User user = User(
      uid: ap.uid!,
      email: ap.email!,
      name: ap.name!,
      phoneNumber: ap.phoneNumber,
    );
    List<FoodOrder> foodOrders = [];
    for (int i = 0; i < widget.carts.length; i++) {
      FoodOrder food = FoodOrder(
        foodName: widget.carts[i].food.name,
        quantity: widget.carts[i].quantity,
        foodPrice: widget.carts[i].price,
        customize: widget.carts[i].customize,
      );
      foodOrders.add(food);
    }

    Order order = Order(
      user: user,
      address: selectedAddress,
      shop: widget.carts[0].shop,
      foodOrders: foodOrders,
      totalPrice: widget.subtotalPrice,
      deliveryPrice: deliveryPrice,
      discountPrice: widget.discountPrice,
      voucherId: widget.voucherId,
      time: DateTime.now().millisecondsSinceEpoch,
      isCutlery: widget.isCutlery,
    );

    String status = await op.saveOrderDetail(order);
    if (status == 'success') {
      if (widget.voucherId != null) {
        await voucherController.markVoucherAsUsed(voucherId: widget.voucherId!);
      }
      Navigator.pushNamed(
        context,
        OrderScreen.routeName,
      );
    } else {
      openSnackbar(context, 'Please wait for the current order to finish!',
          scheme.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.carts[0].shop.shopName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: StickyContainer(
        stickyChildren: [
          StickyWidget(
            initialPosition: StickyPosition(top: 0, right: 0),
            finalPosition: StickyPosition(top: 0, right: 0),
            controller: scrollController,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ProgressStepper(
                isProgess: isProgess,
                activeStep: 3,
              ),
            ),
          ),
        ],
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                BoxContainer(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: scheme.primary,
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Delivery address',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AddressScreen.routeName,
                                      arguments: AddressScreen(
                                        selectedAddress: selectedAddress,
                                        handleChange: (Address newAddress) {
                                          double distance =
                                              Helper().calculateDistance(
                                            newAddress.latitude,
                                            newAddress.longitude,
                                            widget.carts[0].shop.latitude,
                                            widget.carts[0].shop.longitude,
                                          );
                                          double newDeliveryPrice =
                                              distance <= 0.5
                                                  ? 0
                                                  : distance <= 1
                                                      ? 0.3
                                                      : distance * 0.3;

                                          setState(() {
                                            deliveryPrice = double.parse(
                                                newDeliveryPrice
                                                    .toStringAsFixed(2));

                                            selectedAddress = newAddress;
                                          });
                                        },
                                        mapController: mapController,
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: scheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 100,
                              color: Colors.white,
                              child: MapPreview(
                                selectedAddress: selectedAddress,
                                onMapCreated: (GoogleMapController controller) {
                                  setState(() {
                                    mapController = controller;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${selectedAddress.houseNumber.isEmpty ? '' : selectedAddress.houseNumber + ' '}${selectedAddress.street}',
                            ),
                            Text(selectedAddress.province),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.grey[200],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, EditAddressScreen.routeName,
                              arguments: EditAddressScreen(
                                editAddress: selectedAddress,
                                handleChange: (Address newAddress) {
                                  setState(() {
                                    selectedAddress = newAddress;
                                  });
                                },
                                isInstructionFocus: true,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: selectedAddress.deliveryInstruction == ''
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: scheme.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Add delivery instructions',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: scheme.primary,
                                      ),
                                    )
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedAddress.deliveryInstruction!,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: scheme.primary,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.grey[200],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Contactless delivery: switch to online payment for this option',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50),
                            Switch(
                              value: false,
                              activeTrackColor: scheme.primary,
                              activeColor: Colors.white,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                const SizedBox(height: 33),
                BoxContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.credit_card_outlined,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Payment method',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // NOTE: temporary
                            GestureDetector(
                              onTap: () {
                                final op = context.read<OrderProvider>();
                                op.clearCurrentOrder();
                              },
                              child: Icon(
                                Icons.edit_outlined,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              Icons.money_outlined,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Cash',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '\$ ${(widget.subtotalPrice + deliveryPrice - widget.discountPrice).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                BoxContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Order summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.carts.length,
                          itemBuilder: (context, index) {
                            final cart = widget.carts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${cart.quantity}x ${cart.food.name}'),
                                        const SizedBox(height: 5),
                                        Text(
                                          cart.customize,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text('\$ ${cart.price * cart.quantity}')
                                ],
                              ),
                            );
                          },
                        ),
                        Divider(
                          thickness: 1.2,
                          color: Colors.grey[200],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Subtotal',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              '\$ ${widget.subtotalPrice}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Delivery fee',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              '\$ $deliveryPrice',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: widget.discountPrice != 0 ? 10 : 0),
                        widget.discountPrice != 0
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Discount',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '- \$ ${(widget.discountPrice).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    text: 'By placing your order you agree to our ',
                    style: TextStyle(
                      wordSpacing: 1,
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            wordSpacing: 1,
                            color: scheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {}),
                      TextSpan(
                        text:
                            '. We will process your personal data necessary to deliver your order. You can learn more on how we process your personal data in our ',
                        style: TextStyle(
                          wordSpacing: 1,
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            wordSpacing: 1,
                            color: scheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {}),
                      TextSpan(
                        text: '.',
                        style: TextStyle(
                          wordSpacing: 1,
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        title: 'Place order',
        carts: widget.carts,
        subtotalPrice: widget.subtotalPrice,
        deliveryPrice: deliveryPrice,
        discountPrice: widget.discountPrice,
        onClick: placeOrder,
      ),
    );
  }
}
