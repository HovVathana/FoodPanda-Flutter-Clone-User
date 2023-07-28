import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_user/cart/screens/cart_screen.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/providers/cart_provider.dart';
import 'package:foodpanda_user/search/screens/search_screen.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? title;
  final String? subtitle;
  final Builder? leadingIcon;
  final VoidCallback? onTap;

  const MyAppBar({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.title,
    this.subtitle,
    this.leadingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CartProvider>();
    int totalQuantity = 0;

    for (int i = 0; i < cp.cart.length; i++) {
      totalQuantity += cp.cart[i].quantity;
    }

    return SliverAppBar(
      foregroundColor: foregroundColor ?? Colors.white,
      backgroundColor: backgroundColor ?? scheme.primary,
      expandedHeight: 110,
      collapsedHeight: 60,
      forceElevated: true,
      elevation: 0,
      shadowColor: Colors.transparent,
      floating: true,
      pinned: true,
      leading: leadingIcon ??
          BackButton(
            color: foregroundColor == null ? Colors.white : scheme.primary,
          ),
      actions: [
        IconButton(
          visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: Icon(
            Icons.favorite_border_rounded,
            color: foregroundColor == null ? Colors.white : scheme.primary,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: foregroundColor == null ? Colors.white : scheme.primary,
              ),
            ),
            totalQuantity == 0
                ? const SizedBox()
                : Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: foregroundColor == null
                            ? Colors.white
                            : scheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            totalQuantity.toString(),
                            style: TextStyle(
                              color: foregroundColor == null
                                  ? scheme.primary
                                  : Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        )
      ],
      title: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Home',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle ?? '320 St. 320',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SearchScreen.routeName);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 38,
                    decoration: BoxDecoration(
                      color: backgroundColor == scheme.primary
                          ? Colors.white
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_outlined,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Search for shops & restaurants',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
