import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodpanda_user/cart/screens/order_screen.dart';
import 'package:foodpanda_user/cart/widgets/custom_linear_progress.dart';
import 'package:foodpanda_user/cart/widgets/order_screen_without_map.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/constants/helper.dart';
import 'package:foodpanda_user/providers/order_provider.dart';
import 'package:provider/provider.dart';

class ActiveOrderBottomContainer extends StatefulWidget {
  const ActiveOrderBottomContainer({super.key});

  @override
  State<ActiveOrderBottomContainer> createState() =>
      _ActiveOrderBottomContainerState();
}

class _ActiveOrderBottomContainerState
    extends State<ActiveOrderBottomContainer> {
  bool isViewDetail = false;

  getData() async {
    final op = context.read<OrderProvider>();

    await op.detectChanges(orderId: op.currentOrder!.id!);
    // setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  clearCurrentOrder() async {
    final op = context.read<OrderProvider>();
    await op.clearCurrentOrder();
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().currentOrder!;
    double distance = order.rider == null
        ? 5
        : Helper().calculateDistance(
            order.rider!.latitude,
            order.rider!.longitude,
            order.address.latitude,
            order.address.longitude,
          );

    int time = (distance * 4).round();

    if (order.isDelivered) {
      Timer(const Duration(seconds: 10), () {
        clearCurrentOrder();
      });
    }

    return GestureDetector(
      onTap: () {
        final finishedOrder = order;
        !order.isDelivered
            ? Navigator.pushNamed(context, OrderScreen.routeName)
            : Navigator.pushNamed(context, OrderScreenWithoutMap.routeName,
                arguments: OrderScreenWithoutMap(order: finishedOrder));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 2.5, color: Colors.pink[100]!.withAlpha(255)
                        // color: scheme.primary.withOpacity(0.1),
                        ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.shop.shopName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isViewDetail = !isViewDetail;
                    });
                  },
                  child: Icon(
                    isViewDetail
                        ? Icons.keyboard_arrow_up_sharp
                        : Icons.keyboard_arrow_down_sharp,
                    color: scheme.primary,
                    size: 30,
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: CustomLinearProgress(
                              isProgess: !order.isShopAccept,
                              isDone: order.isShopAccept,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomLinearProgress(
                              isProgess: order.isShopAccept,
                              isDone: order.isPickup,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomLinearProgress(
                              isProgess: order.isPickup,
                              isDone: order.isNear,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 35,
                            child: CustomLinearProgress(
                              isProgess: order.isNear,
                              isDone: order.isDelivered,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        order.isDelivered
                            ? 'Enjoy!'
                            : order.isNear
                                ? 'Anytime now! Look out for your rider!'
                                : order.isPickup
                                    ? 'Your rider has picked up your order'
                                    : order.isShopAccept
                                        ? 'Preparing your order. Your rider will pick it up once it\'s ready.'
                                        : 'Got your order ${order.user.name.split(' ')[0]}!',
                        overflow: isViewDetail
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  order.isDelivered
                      ? 'Delivered'
                      : order.isNear
                          ? 'Anytime now'
                          : order.isPickup
                              ? '$time mins'
                              : order.isShopAccept
                                  ? '10 - 15 mins'
                                  : '5 -15 mins',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
