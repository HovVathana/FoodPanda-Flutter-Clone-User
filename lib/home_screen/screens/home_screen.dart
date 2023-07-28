import 'package:flutter/material.dart';
import 'package:foodpanda_user/address/controllers/address_controller.dart';
import 'package:foodpanda_user/address/widgets/select_address_modal.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/food_delivery/controllers/food_delivery_controller.dart';
import 'package:foodpanda_user/food_delivery/screens/food_delivery_screen.dart';
import 'package:foodpanda_user/home_screen/widgets/active_order_bottom_container.dart';
import 'package:foodpanda_user/home_screen/widgets/loading_home_screen.dart';
import 'package:foodpanda_user/home_screen/widgets/my_drawer.dart';
import 'package:foodpanda_user/home_screen/widgets/restaurant_card.dart';
import 'package:foodpanda_user/models/address.dart';
import 'package:foodpanda_user/models/menu.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/providers/authentication_provider.dart';
import 'package:foodpanda_user/providers/cart_provider.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:foodpanda_user/providers/order_provider.dart';
import 'package:foodpanda_user/shop_details/screens/shop_details.dart';
import 'package:foodpanda_user/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FoodDeliveryController foodDeliveryController = FoodDeliveryController();
  List<Shop> shops = [];
  bool isLoading = true;

  Future getData() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    await authenticationProvider.getUserDataFromSharedPreferences();
    await cartProvider.getCartFromSharedPreferences(context);
    shops = await foodDeliveryController.fetchShop(context);
    await orderProvider.getOrderFromSharedPreferences();
    isLoading = false;
    setState(() {});
  }

  getMenu(Shop shop) async {
    List<Menu> menu =
        await foodDeliveryController.fetchCategory(sellerUid: shop.uid);

    Navigator.pushNamed(
      context,
      ShopDetailScreen.routeName,
      arguments: ShopDetailScreen(shop: shop, menu: menu),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final lp = context.watch<LocationProvider>();
    final op = context.watch<OrderProvider>();

    return isLoading
        ? const LoadingHomeScreen()
        : Scaffold(
            drawer: MyDrawer(parentContext: context),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                MyAppBar(
                  title: lp.isCurrentLocation
                      ? 'Current Location'
                      : lp.address!.label!.isNotEmpty
                          ? lp.address!.label
                          : '${lp.address!.houseNumber.isEmpty ? '' : lp.address!.houseNumber + ' '}${lp.address!.street}',
                  subtitle: !lp.isCurrentLocation && lp.address!.label!.isEmpty
                      ? lp.address!.province
                      : '${lp.address!.houseNumber.isEmpty ? '' : lp.address!.houseNumber + ' '}${lp.address!.street}',
                  onTap: () async {
                    List<Address> addressList =
                        await AddressController().fetchAddressArray();
                    addressList.removeWhere((element) {
                      return element.id == lp.address!.id;
                    });
                    showSelectAddressModal(context, addressList);
                  },
                  leadingIcon: Builder(builder: (context) {
                    return IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        color: Colors.grey[200],
                        child: buildCollage(context, height),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Popular Restaurants',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                              height: height * 0.3,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: shops.length,
                                itemBuilder: (context, index) {
                                  final shop = shops[index];

                                  return Row(
                                    children: [
                                      SizedBox(width: index == 0 ? 15 : 0),
                                      GestureDetector(
                                        onTap: () => getMenu(shop),
                                        child: RestaurantCard(shop: shop),
                                      ),
                                      SizedBox(
                                          width: index == shops.length - 1
                                              ? 15
                                              : 10),
                                    ],
                                  );
                                },
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: op.currentOrder != null
                ? const ActiveOrderBottomContainer()
                : const SizedBox(),
          );
  }

  Column buildCollage(BuildContext context, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, FoodDeliveryScreen.routeName);
            },
            child: Container(
              height: height * 0.20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Image(
                      width: 150,
                      image: AssetImage('assets/images/food_delivery.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Food delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'Order food you love',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            height: 1,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: height * 0.35,
                  decoration: BoxDecoration(
                    color: MyColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Positioned(
                        bottom: 5,
                        right: 20,
                        child: Image(
                          width: 100,
                          image: AssetImage('assets/images/shops.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shops',
                              style: TextStyle(
                                color: MyColors.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Groceries and more',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                height: 1,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.25,
                      decoration: BoxDecoration(
                        color: MyColors.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Positioned(
                            bottom: 10,
                            right: 0,
                            child: Image(
                              width: 100,
                              image: AssetImage('assets/images/pick_up.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pick-up',
                                  style: TextStyle(
                                    color: MyColors.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Up to 50% off',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: height * 0.10,
                      decoration: BoxDecoration(
                        color: MyColors.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Positioned(
                            bottom: 5,
                            right: 0,
                            child: Image(
                              width: 55,
                              image: AssetImage('assets/images/pandasend.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'pandasend',
                                  style: TextStyle(
                                    color: MyColors.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Express\nDelivery',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
