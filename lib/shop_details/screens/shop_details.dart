import 'package:flutter/material.dart';
import 'package:foodpanda_user/cart/screens/cart_screen.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/food_delivery/controllers/food_delivery_controller.dart';
import 'package:foodpanda_user/models/menu.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/providers/cart_provider.dart';
import 'package:foodpanda_user/shop_details/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:rect_getter/rect_getter.dart';

class ShopDetailScreen extends StatefulWidget {
  static const String routeName = '/shop-detail-screen';
  final Shop shop;
  final List<Menu> menu;
  const ShopDetailScreen({super.key, required this.shop, required this.menu});

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen>
    with SingleTickerProviderStateMixin {
  FoodDeliveryController foodDeliveryController = FoodDeliveryController();

  late AutoScrollController scrollController;
  late TabController tabController;

  final double expandedHeight = 500.0;
  final double collapsedHeight = kToolbarHeight;

  final listViewKey = RectGetter.createGlobalKey();
  Map<int, dynamic> itemKeys = {};

  // prevent animate when press on tab bar
  bool pauseRectGetterIndex = false;

  bool isCollapsed = false;

  @override
  void initState() {
    // getData();
    tabController = TabController(length: widget.menu.length, vsync: this);
    scrollController = AutoScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  List<int> getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;
    itemKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      if (itemRect.top > rect.bottom) return;
      if (itemRect.bottom < rect.top) return;
      items.add(index);
    });
    return items;
  }

  void onCollapsed(bool value) {
    if (this.isCollapsed == value) return;
    setState(() => this.isCollapsed = value);
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (pauseRectGetterIndex) return true;
    int lastTabIndex = tabController.length - 1;
    List<int> visibleItems = getVisibleItemsIndex();

    bool reachLastTabIndex = visibleItems.isNotEmpty &&
        visibleItems.length <= 2 &&
        visibleItems.last == lastTabIndex;
    if (reachLastTabIndex) {
      tabController.animateTo(lastTabIndex);
    } else if (visibleItems.isNotEmpty) {
      int sumIndex = visibleItems.reduce((value, element) => value + element);
      int middleIndex = sumIndex ~/ visibleItems.length;
      if (tabController.index != middleIndex)
        tabController.animateTo(middleIndex);
    }
    return false;
  }

  void animateAndScrollTo(int index) {
    pauseRectGetterIndex = true;
    tabController.animateTo(index);
    scrollController
        .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        .then((value) => pauseRectGetterIndex = false);
  }

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CartProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: scheme.background,
      body: RectGetter(
        key: listViewKey,
        child: NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: buildSliverScrollView()),
      ),
      bottomNavigationBar:
          cp.cart.isEmpty ? const SizedBox() : bottomContainer(cp),
    );
  }

  Widget bottomContainer(CartProvider cp) {
    int totalQuantity = 0;
    double totalPrice = 0;

    for (int i = 0; i < cp.cart.length; i++) {
      totalQuantity += cp.cart[i].quantity;
      totalPrice += cp.cart[i].price * cp.cart[i].quantity;
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CartScreen.routeName);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    totalQuantity.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Text(
                'View your cart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$ $totalPrice',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSliverScrollView() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      slivers: [
        buildAppBar(),
        buildBody(),
      ],
    );
  }

  SliverAppBar buildAppBar() {
    return FAppBar(
      shop: widget.shop,
      categoriesData: widget.menu,
      context: context,
      scrollController: scrollController,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      isCollapsed: isCollapsed,
      onCollapsed: onCollapsed,
      tabController: tabController,
      onTap: (index) => animateAndScrollTo(index),
    );
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => buildCategoryItem(index),
        childCount: widget.menu.length,
      ),
    );
  }

  Widget buildCategoryItem(int index) {
    itemKeys[index] = RectGetter.createGlobalKey();
    // Menu menuData = widget.menu[index];
    return RectGetter(
      key: itemKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: scrollController,
        child: CategorySection(
          menu: widget.menu[index],
          sellerUid: widget.shop.uid,
          sellerName: widget.shop.shopName,
          shop: widget.shop,
        ),
      ),
    );
  }
}
