import 'package:flutter/material.dart';
import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/cart.dart';
import 'package:foodpanda_user/models/voucher.dart';

class BottomNavigation extends StatelessWidget {
  final double subtotalPrice;
  final double deliveryPrice;
  final double discountPrice;
  final List<Cart> carts;
  final String? title;
  final VoidCallback onClick;
  const BottomNavigation({
    super.key,
    required this.carts,
    this.title,
    required this.subtotalPrice,
    required this.deliveryPrice,
    required this.onClick,
    required this.discountPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: title != null ? 105 : 135,
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '(incl. VAT)',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    Text(
                      '\$ ${(subtotalPrice + deliveryPrice - discountPrice).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                title != null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'See price breakdown',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      )
              ],
            ),
          ),
          CustomTextButton(
            text: title != null ? title! : 'Review payment and address',
            onPressed: onClick,
            isDisabled: false,
          ),
        ],
      ),
    );
  }
}
