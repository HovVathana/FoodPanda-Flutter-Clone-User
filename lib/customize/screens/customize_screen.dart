// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/widgets/my_alert_dialog.dart';
import 'package:provider/provider.dart';

import 'package:foodpanda_user/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_user/cart/screens/cart_screen.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/customize/widgets/customize_card.dart';
import 'package:foodpanda_user/customize/widgets/product_availability.dart';
import 'package:foodpanda_user/customize/widgets/special_instruction.dart';
import 'package:foodpanda_user/food_delivery/controllers/food_delivery_controller.dart';
import 'package:foodpanda_user/models/cart.dart';
import 'package:foodpanda_user/models/customize.dart';
import 'package:foodpanda_user/models/food.dart';
import 'package:foodpanda_user/providers/cart_provider.dart';
import 'package:foodpanda_user/shop_details/widgets/widgets.dart';

class CustomizeScreen extends StatefulWidget {
  static const String routeName = '/customize-screen';
  final Shop shop;
  final String sellerUid;
  final String categoryId;
  final String sellerName;
  final Food food;
  final Cart? cart;
  final int? cartIndex;

  CustomizeScreen({
    Key? key,
    required this.sellerUid,
    required this.categoryId,
    required this.sellerName,
    required this.food,
    this.cartIndex,
    this.cart,
    required this.shop,
  }) : super(key: key);

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  TextEditingController instructionController = TextEditingController();
  int quantity = 1;

  FoodDeliveryController foodDeliveryController = FoodDeliveryController();
  List<Customize> customize = [];

  List<dynamic> requiredSelectedChoice = [];
  bool isAddToCart = false;
  List<dynamic> optionalSelectedChoice = [];

  List<List<bool>> optionalIsSelected = [];

  int requiredChoiceLength = 0;

  String productAvailabilityChoice = 'Remove it from my order';

  List<String>? editCustomize;

  getCustomize() async {
    customize = await foodDeliveryController.fetchCustomize(
      sellerUid: widget.sellerUid,
      categoriesId: widget.categoryId,
      foodId: widget.food.id,
    );

    if (customize.length == 0) {
      isAddToCart = true;
    }

    for (int i = 0; i < customize.length; i++) {
      if (customize[i].isRequired) {
        requiredChoiceLength++;
      }
    }

    requiredSelectedChoice = widget.cart == null
        ? List.generate(customize.length, (index) => null)
        : widget.cart!.requiredSelectedChoice;

    if (widget.cart != null) {
      optionalIsSelected = widget.cart!.optionalIsSelected;
      quantity = widget.cart!.quantity;
    } else {
      for (int i = 0; i < customize.length - requiredChoiceLength; i++) {
        int customizeIndex = customize.length - requiredChoiceLength + i + 1;

        List<bool> temp = List.generate(
            customize[customizeIndex].choices.length, (index) => false);
        optionalIsSelected.add(temp);
      }
    }
    checkIsAddToCart();

    setState(() {});
  }

  @override
  void initState() {
    getCustomize();

    // optionalIsSelected = List.generate(
    //     customize.length - requiredChoiceLength, (index) => [false]);

    if (widget.cart != null) {
      optionalSelectedChoice = widget.cart!.optionalSelectedChoice;
      setState(() {
        editCustomize = widget.cart!.customize.split(', ');
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    instructionController.dispose();
  }

  handleAddToCart() async {
    final cp = context.read<CartProvider>();
    if (cp.cart.isEmpty) {
      addToCart();
    } else {
      if (cp.cart[0].shop.uid == widget.shop.uid) {
        addToCart();
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return MyAlertDialog(
                  title: 'Remove your previous items?',
                  subtitle:
                      'You still have products from another restaurant. Shall we start over with a fresh cart?',
                  action1Name: 'No',
                  action2Name: 'Remove',
                  action1Func: () {
                    Navigator.pop(context);
                  },
                  action2Func: () async {
                    Navigator.pop(context);
                    await cp.clearCart();
                    addToCart();
                  });
            });
      }
    }
  }

  addToCart() async {
    requiredSelectedChoice.removeWhere((element) => element == null);

    double totalPrice = 0;
    List<String> orderCaptionList = [];

    List<Choice> requiredSelected = [];
    List<Choice> optionalSelected = [];

    double totalRequiredPrice = customize.length == 0
        ? widget.food.price
        : customize[0].isVariation
            ? 0
            : widget.food.price;
    for (int i = 0; i < requiredSelectedChoice.length; i++) {
      totalRequiredPrice += requiredSelectedChoice[i].price;
      orderCaptionList.add(requiredSelectedChoice[i].choice);
      requiredSelected.add(
        Choice(
          choice: requiredSelectedChoice[i].choice,
          price: requiredSelectedChoice[i].price,
        ),
      );
    }

    double totalOptionalPrice = 0;
    for (int i = 0; i < optionalSelectedChoice.length; i++) {
      totalOptionalPrice += optionalSelectedChoice[i].price;
      orderCaptionList.add(optionalSelectedChoice[i].choice);
      optionalSelected.add(
        Choice(
          choice: optionalSelectedChoice[i].choice,
          price: optionalSelectedChoice[i].price,
        ),
      );
    }

    totalPrice = totalRequiredPrice + totalOptionalPrice;
    String orderCaption = orderCaptionList.join(', ');

    Cart cartData = Cart(
      shop: widget.shop,
      food: widget.food,
      customize: orderCaption,
      price: totalPrice,
      deliveryPrice: 0,
      quantity: quantity,
      categoriesId: widget.categoryId,
      requiredSelectedChoice: requiredSelected,
      optionalSelectedChoice: optionalSelected,
      optionalIsSelected: optionalIsSelected,
    );

    final cartProvider = context.read<CartProvider>();

    if (widget.cartIndex != null && widget.cart != null) {
      await cartProvider.editCart(index: widget.cartIndex!, cartData: cartData);
      Navigator.pushReplacementNamed(context, CartScreen.routeName);
    } else {
      await cartProvider.addCart(cartData: cartData);
      Navigator.pop(context);
    }
  }

  checkIsAddToCart() {
    var choices = [...requiredSelectedChoice];
    choices.removeWhere((element) => element == null);
    setState(() {
      isAddToCart = choices.length == requiredChoiceLength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverLayoutBuilder(builder: (context, constaints) {
            final scrolled = constaints.scrollOffset <= 185;
            return SliverAppBar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              expandedHeight: 250,
              collapsedHeight: 60,
              forceElevated: true,
              elevation: 0.5,
              pinned: true,
              leading: Center(
                child: FIconButton(
                  onPressed: () {
                    widget.cart != null
                        ? Navigator.pushReplacementNamed(
                            context, CartScreen.routeName)
                        : Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              title: scrolled
                  ? const SizedBox()
                  : const Text(
                      'Customize',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.food.image,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.network(
                      widget.food.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.food.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        'from \$ ${widget.food.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.food.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Divider(
                      color: Colors.grey[300],
                    ),
                  ),
                  customize.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: customize.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CustomizeCard(
                                customize: customize[index],
                                editCustomize: editCustomize != null
                                    ? index < requiredChoiceLength
                                        ? editCustomize![index]
                                        : null
                                    : null,
                                optionalIsSelected:
                                    index >= requiredChoiceLength
                                        ? optionalIsSelected[
                                            index - requiredChoiceLength]
                                        : null,
                                onRadioChanged: (Choice value) {
                                  setState(() {
                                    requiredSelectedChoice[index] = value;
                                  });

                                  checkIsAddToCart();
                                },
                                onSelectChanged:
                                    (Choice value, bool isSelected) {
                                  var matchChoice;
                                  if (!isSelected) {
                                    matchChoice =
                                        optionalSelectedChoice.firstWhere((x) =>
                                            x.choice == value.choice &&
                                            x.price == value.price);
                                  }
                                  setState(() {
                                    isSelected
                                        ? optionalSelectedChoice.add(value)
                                        : optionalSelectedChoice
                                            .remove(matchChoice ?? value);
                                  });
                                },
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Divider(
                      color: Colors.grey[300],
                    ),
                  ),
                  SpecialInstruction(
                    instructionController: instructionController,
                  ),
                  const SizedBox(height: 50),
                  ProductAvailability(
                      value: productAvailabilityChoice,
                      onChanged: (String option) {
                        setState(() {
                          productAvailabilityChoice = option;
                        });
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: MyColors.backgroundColor,
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
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FIconButton(
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity -= 1;
                      }
                    });
                  },
                  backgroundColor: scheme.primary,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FIconButton(
                  onPressed: () {
                    setState(() {
                      if (quantity >= 0) {
                        quantity += 1;
                      }
                    });
                  },
                  backgroundColor: scheme.primary,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: CustomTextButton(
                text: widget.cart != null ? 'Update' : 'Add to cart',
                onPressed: handleAddToCart,
                isDisabled: !isAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
