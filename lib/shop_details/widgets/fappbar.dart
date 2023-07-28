import 'package:flutter/material.dart';
import 'package:foodpanda_user/constants/colors.dart';
import 'package:foodpanda_user/helpers/helper.dart';
import 'package:foodpanda_user/models/menu.dart';
import 'package:foodpanda_user/models/shop.dart';
import 'package:foodpanda_user/shop_details/widgets/discount_card.dart';
import 'package:foodpanda_user/shop_details/widgets/ficon_button.dart';
import 'package:foodpanda_user/shop_details/widgets/header_clip.dart';
import 'package:foodpanda_user/shop_details/widgets/panda_head.dart';
import 'package:foodpanda_user/shop_details/widgets/promo_text.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class FAppBar extends SliverAppBar {
  final Shop shop;
  final List<Menu> categoriesData;
  final BuildContext context;
  final bool isCollapsed;
  final double expandedHeight;
  final double collapsedHeight;
  final AutoScrollController scrollController;
  final TabController tabController;
  final void Function(bool isCollapsed) onCollapsed;
  final void Function(int index) onTap;

  FAppBar({
    required this.shop,
    required this.categoriesData,
    required this.context,
    required this.isCollapsed,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.scrollController,
    required this.onCollapsed,
    required this.onTap,
    required this.tabController,
  }) : super(elevation: 4.0, pinned: true, forceElevated: true);

  @override
  Color? get backgroundColor => scheme.surface;

  @override
  Widget? get leading {
    return Center(
      child: FIconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: backgroundColor,
        icon: Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  List<Widget>? get actions {
    return [
      FIconButton(
        backgroundColor: backgroundColor,
        onPressed: () {},
        icon: Icon(Icons.share_outlined),
      ),
      FIconButton(
        backgroundColor: backgroundColor,
        onPressed: () {},
        icon: Icon(Icons.info_outline),
      ),
    ];
  }

  @override
  Widget? get title {
    var textTheme = Theme.of(context).textTheme;
    return AnimatedOpacity(
      opacity: this.isCollapsed ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery",
            style: textTheme.subtitle1?.copyWith(color: scheme.onSurface),
            strutStyle: Helper.buildStrutStyle(textTheme.subtitle1),
          ),
          const SizedBox(height: 4.0),
          Text(
            shop.remainingTime.toString() + ' min',
            style: textTheme.caption?.copyWith(color: scheme.primary),
            strutStyle: Helper.buildStrutStyle(textTheme.caption),
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? get bottom {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: scheme.surface,
        child: TabBar(
          isScrollable: true,
          controller: tabController,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          indicatorColor: scheme.primary,
          labelColor: scheme.primary,
          unselectedLabelColor: scheme.onSurface,
          indicatorWeight: 3.0,
          tabs: categoriesData.map((e) {
            return Tab(text: e.category.title);
          }).toList(),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget? get flexibleSpace {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final top = constraints.constrainHeight();
        final collapsedHight =
            MediaQuery.of(context).viewPadding.top + kToolbarHeight + 48;
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          onCollapsed(collapsedHight != top);
        });

        return FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Column(
            children: [
              Stack(
                children: [
                  PromoText(
                      title:
                          'ប្រើកូដ HELLOPANDA បញ្ចុះតម្លៃ 50% សម្រាប់ការកុម៉្មងលើកដំបូងចាប់ពី 4.5\$ ឡើងទៅ'),
                  const PandaHead(),
                  Column(
                    children: [
                      HeaderClip(context: context, shop: shop),
                      const SizedBox(height: 110),
                    ],
                  ),
                ],
              ),
              DiscountCard(
                title: '30% Discount',
                subtitle: 'On the entire menu',
              ),
            ],
          ),
        );
      },
    );
  }
}
