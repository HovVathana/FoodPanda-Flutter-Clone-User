import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/shop_details/widgets/custom_shape.dart';

class HeaderClip extends StatelessWidget {
  final Shop shop;
  final BuildContext context;

  const HeaderClip({
    Key? key,
    required this.context,
    required this.shop,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) {
    final textTheme = Theme.of(context).textTheme;
    return ClipPath(
      clipper: CustomShape(),
      child: Stack(
        children: [
          Container(
            height: 275,
            color: scheme.primary,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/transparent.png',
              image: shop.shopImage,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 275,
            color: scheme.secondary.withOpacity(0.7),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + kToolbarHeight,
            ),
            child: Column(
              children: [
                const SizedBox(height: 4.0),
                Text(
                  shop.shopName,
                  style: textTheme.headline5?.copyWith(
                    color: scheme.surface,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: scheme.surface),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Delivery: ${shop.remainingTime} min",
                      style: textTheme.caption?.copyWith(color: scheme.surface),
                      strutStyle: StrutStyle(forceStrutHeight: true),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      size: 16,
                      color: scheme.surface,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      shop.rating.toString(),
                      style: textTheme.caption?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.surface,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      "(" + shop.totalRating.toString() + ")",
                      style: textTheme.caption?.copyWith(
                        color: scheme.surface,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
