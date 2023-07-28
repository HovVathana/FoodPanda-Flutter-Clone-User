import 'package:flutter/material.dart';
import 'package:flutter_sticky_widgets/flutter_sticky_widgets.dart';
import 'package:foodpanda_user/cart/screens/checkout_screen.dart';
import 'package:foodpanda_user/cart/widgets/bottom_navigation.dart';
import 'package:foodpanda_user/cart/widgets/cutlery_switch.dart';
import 'package:foodpanda_user/cart/widgets/estimate_card.dart';
import 'package:foodpanda_user/cart/widgets/product_card.dart';
import 'package:foodpanda_user/cart/widgets/progress_stepper.dart';
import 'package:foodpanda_user/cart/widgets/subtotal_card.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/customize/screens/customize_screen.dart';
import 'package:foodpanda_user/food_delivery/controllers/food_delivery_controller.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/models/cart.dart';
import 'package:foodpanda_user/models/menu.dart';
import 'package:foodpanda_user/models/voucher.dart';
import 'package:foodpanda_user/providers/cart_provider.dart';
import 'package:foodpanda_user/shop_details/screens/shop_details.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isCutlery = true;
  List<int> quantity = [];
  List<bool> isQuantityClick = [];
  List<Cart> carts = [];
  double subtotalPrice = 0;
  double deliveryPrice = 0;
  bool isProgess = true;
  Voucher? voucher;

  ScrollController scrollController = ScrollController();

  getData() async {
    final cartProvider = context.read<CartProvider>();

    await cartProvider.getCartFromSharedPreferences(context);

    carts = cartProvider.cart;

    isQuantityClick = List.generate(carts.length, (index) => false);
    for (int i = 0; i < carts.length; i++) {
      quantity.add(carts[i].quantity);
      subtotalPrice += carts[i].quantity * carts[i].price;
    }
    if (carts.isNotEmpty) {
      deliveryPrice = carts[0].shop.deliveryPrice!;
    }
    setState(() {});
  }

  changeQuantity({required int index, required int quantity}) async {
    final cartProvider = context.read<CartProvider>();

    await cartProvider.changeQuantity(index: index, quantity: quantity);
  }

  removeCart(int index) async {
    final cartProvider = context.read<CartProvider>();

    await cartProvider.removeCart(index: index);
  }

  @override
  void initState() {
    getData();
    scrollController.addListener(() {
      if (scrollController.offset > 43.262162642045496) {
        setState(() {
          isProgess = false;
        });
      } else {
        setState(() {
          isProgess = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double discountPrice = 0;
    if (voucher != null) {
      double minPrice = voucher!.minPrice ?? 0;
      if (subtotalPrice >= minPrice) {
        if (voucher!.discountPrice != null) {
          discountPrice = voucher!.discountPrice!;
        } else {
          discountPrice = voucher!.discountPercentage! / 100 * subtotalPrice;
        }
      }
    }

    return carts.isEmpty
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: scheme.primary,
              title: const Text(
                'Cart',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/foodpanda_cart.png',
                    width: 150,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    textAlign: TextAlign.center,
                    'Hungry?',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    textAlign: TextAlign.center,
                    'You haven\'t added anything to your cart!',
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    splashColor: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Browse',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: scheme.primary,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    carts[0].shop.shopName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                )
              ],
            ),
            body: StickyContainer(
              stickyChildren: [
                StickyWidget(
                  initialPosition: StickyPosition(top: 0, right: 0),
                  finalPosition: StickyPosition(top: 0, right: 0),
                  controller: scrollController,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ProgressStepper(
                      isProgess: isProgess,
                      activeStep: 2,
                    ),
                  ),
                ),
              ],
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          EstimateCard(
                            remainingTime: carts[0].shop.remainingTime!,
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: carts.length,
                            itemBuilder: (context, index) {
                              final cart = carts[index];
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isQuantityClick[index] =
                                                      !isQuantityClick[index];
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 5, 2, 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: Colors.grey[300]!,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      quantity[index]
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      color: scheme.primary,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: ProductCard(
                                                  cart: cart,
                                                  onTap: () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            CustomizeScreen
                                                                .routeName,
                                                            arguments:
                                                                CustomizeScreen(
                                                              sellerUid:
                                                                  cart.shop.uid,
                                                              food: cart.food,
                                                              categoryId: cart
                                                                  .categoriesId,
                                                              sellerName: cart
                                                                  .shop
                                                                  .shopName,
                                                              cart: cart,
                                                              cartIndex: index,
                                                              shop: cart.shop,
                                                            ));
                                                  }),
                                            ),
                                          ],
                                        ),
                                        isQuantityClick[index]
                                            ? Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Container(
                                                  // width: double.infinity,
                                                  width: 1000,
                                                  height: 1000,
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                ))
                                            : const SizedBox(),
                                        isQuantityClick[index]
                                            ? Positioned(
                                                left: 0,
                                                top: 7,
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            isQuantityClick[
                                                                index] = false;
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey[
                                                                        100]!),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Text(
                                                            quantity[index]
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Container(
                                                          width: 120,
                                                          height: 50,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey[
                                                                        100]!),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (quantity[
                                                                          index] ==
                                                                      1) {
                                                                    removeCart(
                                                                        index);
                                                                    setState(
                                                                        () {
                                                                      // carts.removeAt(
                                                                      //     index);
                                                                      quantity.removeAt(
                                                                          index);
                                                                      isQuantityClick
                                                                          .removeAt(
                                                                              index);
                                                                    });

                                                                    // remove the cart item
                                                                  } else if (quantity[
                                                                          index] >=
                                                                      2) {
                                                                    setState(
                                                                        () {
                                                                      quantity[
                                                                          index]--;
                                                                      subtotalPrice -=
                                                                          cart.price;
                                                                    });
                                                                    changeQuantity(
                                                                      index:
                                                                          index,
                                                                      quantity:
                                                                          quantity[
                                                                              index],
                                                                    );
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: scheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                              Container(
                                                                color: Colors
                                                                    .grey[200],
                                                                width: 1,
                                                                height: 20,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    quantity[
                                                                        index]++;
                                                                    subtotalPrice +=
                                                                        cart.price;
                                                                  });
                                                                  changeQuantity(
                                                                      index:
                                                                          index,
                                                                      quantity:
                                                                          quantity[
                                                                              index]);
                                                                },
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: scheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 0.5,
                                  )
                                ],
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () async {
                              FoodDeliveryController foodDeliveryController =
                                  FoodDeliveryController();

                              List<Menu> menu = await foodDeliveryController
                                  .fetchCategory(sellerUid: carts[0].shop.uid);
                              Navigator.pushReplacementNamed(
                                context,
                                ShopDetailScreen.routeName,
                                arguments: ShopDetailScreen(
                                  shop: carts[0].shop,
                                  menu: menu,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                              child: Text(
                                'Add more items',
                                style: TextStyle(
                                  color: scheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 8,
                      color: Colors.grey[100],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SubtotalCard(
                              subtotalPrice: subtotalPrice,
                              deliveryPrice: deliveryPrice,
                              voucher: voucher,
                              setVoucher: (Voucher? newVoucher) {
                                setState(() {
                                  voucher = newVoucher;
                                });
                              }),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 8,
                      color: Colors.grey[100],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Column(
                        children: [
                          CutlerySwitch(
                            isCutlery: isCutlery,
                            onChanged: (bool value) {
                              setState(() {
                                isCutlery = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigation(
                subtotalPrice: subtotalPrice,
                deliveryPrice: deliveryPrice,
                discountPrice: discountPrice,
                carts: carts,
                onClick: () {
                  Navigator.pushNamed(
                    context,
                    CheckoutScreen.routeName,
                    arguments: CheckoutScreen(
                      carts: carts,
                      isCutlery: isCutlery,
                      deliveryPrice: deliveryPrice,
                      subtotalPrice: subtotalPrice,
                      discountPrice: discountPrice,
                      voucherId: voucher != null ? voucher!.id : null,
                    ),
                  );
                }),
          );
  }
}
