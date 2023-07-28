import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/order.dart';

class ViewDetail extends StatefulWidget {
  final Order order;
  const ViewDetail({super.key, required this.order});

  @override
  State<ViewDetail> createState() => _ViewDetailState();
}

class _ViewDetailState extends State<ViewDetail> {
  bool isViewDetail = false;

  @override
  Widget build(BuildContext context) {
    int quantity = 0;
    for (int i = 0; i < widget.order.foodOrders.length; i++) {
      quantity += widget.order.foodOrders[i].quantity;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isViewDetail = !isViewDetail;
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15),
            child: Row(
              children: [
                const Text(
                  'View details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '($quantity items)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Icon(
                  isViewDetail
                      ? Icons.keyboard_arrow_up_sharp
                      : Icons.keyboard_arrow_down_sharp,
                  color: scheme.primary,
                  size: 30,
                )
              ],
            ),
          ),
        ),
        isViewDetail
            ? Container(
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.order.foodOrders.length,
                        itemBuilder: (context, index) {
                          final food = widget.order.foodOrders[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${food.quantity}x',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.foodName,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '75% of Sugar',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  '\$ ${food.foodPrice * food.quantity}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$ ${widget.order.totalPrice}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery fee',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '\$ ${widget.order.deliveryPrice}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          widget.order.discountPrice != 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Discount',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '- \$ ${(widget.order.discountPrice).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          // const SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'VAT',
                          //       style: TextStyle(
                          //         fontSize: 15,
                          //       ),
                          //     ),
                          //     Text(
                          //       '\$ 0.02',
                          //       style: TextStyle(
                          //         fontSize: 15,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total (incl. VAT)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$ ${(widget.order.totalPrice + widget.order.deliveryPrice - widget.order.discountPrice).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Paid with',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.money_outlined,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 25),
                                const Expanded(
                                  child: Text(
                                    'cash on delivery',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$ ${(widget.order.totalPrice + widget.order.deliveryPrice - widget.order.discountPrice).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(
                      height: 0,
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
