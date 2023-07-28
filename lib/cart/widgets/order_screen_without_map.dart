import 'package:flutter/material.dart';
import 'package:foodpanda_user/cart/screens/help_screen.dart';
import 'package:foodpanda_user/cart/widgets/order_screen_info.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/order.dart';

class OrderScreenWithoutMap extends StatelessWidget {
  static const String routeName = '/order-without-map-screen';

  final Order order;

  const OrderScreenWithoutMap({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your order',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              order.shop.shopName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            )
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    HelpScreen.routeName,
                    arguments: HelpScreen(
                      voucherId: order.voucherId,
                    ),
                  );
                },
                child: Text(
                  'Help',
                  style: TextStyle(
                    color: scheme.primary,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: OrderScreenInfo(order: order),
      ),
    );
  }
}
