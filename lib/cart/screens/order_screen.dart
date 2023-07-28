import 'package:flutter/material.dart';
import 'package:foodpanda_user/cart/widgets/order_screen_with_map.dart';
import 'package:foodpanda_user/cart/widgets/order_screen_without_map.dart';
import 'package:foodpanda_user/providers/order_provider.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '/order-screen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  getData() async {
    final op = context.read<OrderProvider>();

    await op.detectChanges(orderId: op.currentOrder!.id!);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().currentOrder;

    if (order != null && order.isDelivered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final finishedOrder = order;
        Navigator.pushReplacementNamed(context, OrderScreenWithoutMap.routeName,
            arguments: OrderScreenWithoutMap(order: finishedOrder));
      });
    }

    return order != null
        ? !order.isPickup
            ? OrderScreenWithoutMap(order: order)
            : !order.isDelivered
                ? OrderScreenWithMap(order: order)
                : const SizedBox()
        : const SizedBox();
  }
}
