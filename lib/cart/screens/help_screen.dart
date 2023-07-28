import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/providers/order_provider.dart';
import 'package:foodpanda_user/shop_details/widgets/text_tag.dart';
import 'package:foodpanda_user/voucher/controllers/voucher_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatefulWidget {
  static const String routeName = '/help-screen';
  final String? voucherId;
  const HelpScreen({super.key, this.voucherId});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool isSeeMore = false;

  cancelledOrder(order) async {
    final op = context.read<OrderProvider>();
    VoucherController voucherController = VoucherController();

    await op.cancelOrder(order);
    if (widget.voucherId != null) {
      await voucherController.unmarkVoucherAsUsed(voucherId: widget.voucherId!);
    }

    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().currentOrder;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        title: const Text(
          'Order Detail',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: order != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.shop.shopName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Today, ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(order.time))}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextTag(
                        text: order.isShopAccept ? 'Preparing' : 'Waiting',
                        backgroundColor: scheme.primary.withOpacity(0.2),
                        textColor: scheme.primary,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: order.isShopAccept
                      ? () {
                          setState(() {
                            isSeeMore = true;
                          });
                        }
                      : () => cancelledOrder(order),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Can I cancel my order?',
                          style: TextStyle(
                            fontSize: 16,
                            color: order.isShopAccept
                                ? Colors.grey[700]
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                isSeeMore
                    ? Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Our partner is already preparing your order. We can\'t cancel it now as that would mean wastage for our partner.\n\nWe\'re doing better to improve our delivery times so we can get your order to you as soon as possible!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            )
          : const SizedBox(),
    );
  }
}
