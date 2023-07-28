import 'package:flutter/material.dart';
import 'package:foodpanda_user/cart/widgets/custom_linear_progress.dart';
import 'package:foodpanda_user/cart/widgets/view_detail.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/constants/helper.dart';
import 'package:foodpanda_user/models/order.dart';
import 'package:foodpanda_user/shop_details/widgets/text_tag.dart';

class OrderScreenInfo extends StatelessWidget {
  final Order order;
  const OrderScreenInfo({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    double distance = order.rider == null
        ? 5
        : Helper().calculateDistance(
            order.rider!.latitude,
            order.rider!.longitude,
            order.address.latitude,
            order.address.longitude,
          );

    int time = (distance * 4).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !order.isPickup
            ? Container(
                width: double.infinity,
                height: 6,
                color: scheme.primary,
              )
            : const SizedBox(),
        SizedBox(height: !order.isPickup || order.isDelivered ? 60 : 0),
        Center(
          child: Column(
            children: [
              !order.isPickup || order.isDelivered
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey[200],
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/foodpanda_location.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 40),
              const Text(
                'Estimated delivery time',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                order.isDelivered
                    ? 'Delivered'
                    : order.isNear
                        ? 'Anytime now'
                        : order.isPickup
                            ? '$time mins'
                            : order.isShopAccept
                                ? '10 - 15 mins'
                                : '5 - 15 mins',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 20),
              !order.isDelivered
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
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
                            width: 70,
                            child: CustomLinearProgress(
                              isProgess: order.isNear,
                              isDone: order.isDelivered,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: !order.isDelivered ? 20 : 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  order.isDelivered
                      ? 'Enjoy!'
                      : order.isNear
                          ? 'Anytime now! Look out for your rider!'
                          : order.isPickup
                              ? 'Your rider has picked up your order'
                              : order.isShopAccept
                                  ? 'Preparing your order. Your rider will pick it up once it\'s ready.'
                                  : 'Got your order ${order.user.name.split(' ')[0]}!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[100]!.withOpacity(0.5),
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Colors.grey[200]!,
              ),
            ),
          ),
        ),
        SizedBox(height: order.isPickup && !order.isDelivered ? 20 : 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              order.isPickup && !order.isDelivered
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/foodpanda_panda.png'),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact your rider',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Ask for contactless\ndelivery',
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                          Icon(
                            Icons.message_outlined,
                            color: scheme.primary,
                            size: 30,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 40),
              const Text(
                'Order Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order number',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextTag(
                    text: order.id!,
                    backgroundColor: Colors.grey[200]!,
                    textColor: Colors.grey[600]!,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order from',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 50,
                    child: Text(
                      order.shop.shopName,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Delivery address',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 50,
                    child: Text(
                      '${order.address.houseNumber} ${order.address.street} ${order.address.province}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total (incl. VAT)',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 50,
                    child: Text(
                      '\$ ${(order.totalPrice + order.deliveryPrice - order.discountPrice).toStringAsFixed(2)}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          thickness: 1,
          color: Colors.grey[200],
        ),
        ViewDetail(
          order: order,
        ),
        Divider(
          thickness: 1,
          height: 0,
          color: Colors.grey[200],
        ),
      ],
    );
  }
}
