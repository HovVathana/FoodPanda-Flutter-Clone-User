import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/cart.dart';

class ProductCard extends StatelessWidget {
  final Cart cart;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.cart,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        cart.food.image,
                      ),
                    )),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        cart.food.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    cart.customize != ''
                        ? Text(
                            cart.customize,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[700]!,
                              fontSize: 12,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
        Text(
          '\$ ${cart.price * cart.quantity}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
