import 'package:flutter/cupertino.dart';
import 'package:foodpanda_user/food_delivery/controllers/food_delivery_controller.dart';
import 'package:foodpanda_user/home_screen/widgets/restaurant_card.dart';
import 'package:foodpanda_user/models/menu.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/shop_details/screens/shop_details.dart';

class ShopSearch extends StatelessWidget {
  final List<Shop> shops;
  final String search;
  const ShopSearch({
    super.key,
    required this.shops,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    getMenu(Shop shop) async {
      FoodDeliveryController foodDeliveryController = FoodDeliveryController();

      List<Menu> menu =
          await foodDeliveryController.fetchCategory(sellerUid: shop.uid);

      Navigator.pushNamed(
        context,
        ShopDetailScreen.routeName,
        arguments: ShopDetailScreen(shop: shop, menu: menu),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${shops.length} results for \'$search\'',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: shops.length,
              itemBuilder: ((context, index) {
                final shop = shops[index];
                return GestureDetector(
                  onTap: () => getMenu(shop),
                  child: RestaurantCard(shop: shop),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
