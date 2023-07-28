import 'package:flutter/material.dart';
import 'package:foodpanda_user/models/voucher.dart';
import 'package:intl/intl.dart';

Future<void> showVoucherDetailModal({
  required BuildContext context,
  required Voucher voucher,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              child: const Text(
                'Voucher details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Divider(
              height: 0,
              thickness: 1,
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    width: 35,
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/percentage_icon.png'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucher.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          voucher.isNewUser
                              ? 'New customers'
                              : 'New and existing customers',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Valid from ${DateFormat('d MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(voucher.startingDate))} - ${DateFormat('d MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(voucher.expiredDate))}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Terms and Condition',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '•',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                'Valid for a minimum order of \$${NumberFormat("###.##", "en_US").format(voucher.minPrice)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '•',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                'For selected users only',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '•',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                'foodpanda may at any time in its sole and absolute discretion exclude, void, discontinue or disqualify you from any voucher, deal, or promotion without prior notice.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '•',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                'foodpanda may at any time in its sole and absolute discretion withdraw, amend and/or alter any applicable terms and conditions of the voucher, deals, or promotions without prior notice.',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
