import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/voucher.dart';
import 'package:foodpanda_user/voucher/screens/apply_voucher_screen.dart';
import 'package:foodpanda_user/voucher/widgets/extended_voucher_card.dart';
import 'package:foodpanda_user/voucher/widgets/voucher_card.dart';

class SubtotalCard extends StatelessWidget {
  final double subtotalPrice;
  final double deliveryPrice;
  final Voucher? voucher;
  final Function(Voucher?) setVoucher;
  const SubtotalCard({
    super.key,
    required this.subtotalPrice,
    required this.deliveryPrice,
    this.voucher,
    required this.setVoucher,
  });

  @override
  Widget build(BuildContext context) {
    double minPrice = voucher == null ? 0 : voucher!.minPrice ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subtotal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '\$ $subtotalPrice',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Delivery fee',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text('\$ $deliveryPrice'),
          ],
        ),
        const SizedBox(height: 15),
        voucher == null
            ? GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ApplyVoucherScreen.routeName,
                    arguments: ApplyVoucherScreen(
                      subtotal: subtotalPrice,
                      setVoucher: setVoucher,
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Apply a voucher',
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  ExtendedVoucherCard(
                    minPrice: voucher!.minPrice ?? 0,
                    currentPrice: subtotalPrice,
                    isCartMode: true,
                  ),
                  VoucherCard(
                    voucher: voucher!,
                    setVoucher: setVoucher,
                    isCartMode: true,
                    isApplied: minPrice - subtotalPrice <= 0,
                    subtotal: subtotalPrice,
                  ),
                ],
              ),
      ],
    );
  }
}
