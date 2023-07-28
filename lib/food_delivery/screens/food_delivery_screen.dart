import 'package:flutter/material.dart';
import 'package:foodpanda_user/banner/screens/banner_screen.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/food_delivery/controllers/food_delivery_controller.dart';
import 'package:foodpanda_user/models/menu.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/home_screen/widgets/restaurant_card.dart';
import 'package:foodpanda_user/providers/location_provider.dart';
import 'package:foodpanda_user/shop_details/screens/shop_details.dart';
import 'package:foodpanda_user/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:foodpanda_user/models/banner.dart' as banner;

class FoodDeliveryScreen extends StatefulWidget {
  static const String routeName = '/food-delivery-screen';
  const FoodDeliveryScreen({super.key});

  @override
  State<FoodDeliveryScreen> createState() => _FoodDeliveryScreenState();
}

class _FoodDeliveryScreenState extends State<FoodDeliveryScreen> {
  FoodDeliveryController foodDeliveryController = FoodDeliveryController();
  List<Shop> shops = [];
  List<banner.Banner> banners = [];

  getShop() async {
    shops = await foodDeliveryController.fetchShop(context);
    setState(() {});
  }

  getBanner() async {
    banners = await foodDeliveryController.fetchBanner();
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
    getShop();
    getBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final lp = context.watch<LocationProvider>();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          MyAppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: lp.isCurrentLocation
                ? 'Current Location'
                : lp.address!.label!.isNotEmpty
                    ? lp.address!.label
                    : '${lp.address!.houseNumber.isEmpty ? '' : lp.address!.houseNumber + ' '}${lp.address!.street}',
            subtitle: 'Food delivery',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: banners.isEmpty ? 0 : height * 0.2,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: banners.length,
                        itemBuilder: (context, index) {
                          final banner = banners[index];
                          return Padding(
                            padding: index == 0
                                ? const EdgeInsets.only(left: 15, right: 10)
                                : index == banners.length - 1
                                    ? const EdgeInsets.only(right: 15)
                                    : const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  BannerScreen.routeName,
                                  arguments: BannerScreen(banner: banner),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 4 / 5,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(banner.imageUrl),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Local Hero',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'See all',
                          style: TextStyle(
                            color: scheme.primary,
                          ),
                        )
                      ],
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
                                  width: index == shops.length - 1 ? 15 : 10),
                            ],
                          );
                        },
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'All restaurants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        return GestureDetector(
                          onTap: () => getMenu(shop),
                          child: RestaurantCard(shop: shop),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
