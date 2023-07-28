import 'package:flutter/material.dart';
import 'package:foodpanda_user/address/screens/address_screen.dart';
import 'package:foodpanda_user/address/screens/edit_address_screen.dart';
import 'package:foodpanda_user/authentication/screens/email_authentication_screen.dart';
import 'package:foodpanda_user/authentication/screens/fill_account_info_screen.dart';
import 'package:foodpanda_user/authentication/screens/login_with_email_screen.dart';
import 'package:foodpanda_user/authentication/screens/phone_number_register_screen.dart';
import 'package:foodpanda_user/authentication/screens/phone_otp_screen.dart';
import 'package:foodpanda_user/authentication/screens/send_verification_email_screen.dart';
import 'package:foodpanda_user/banner/screens/banner_screen.dart';
import 'package:foodpanda_user/cart/screens/cart_screen.dart';
import 'package:foodpanda_user/cart/screens/checkout_screen.dart';
import 'package:foodpanda_user/cart/screens/help_screen.dart';
import 'package:foodpanda_user/cart/screens/order_screen.dart';
import 'package:foodpanda_user/cart/widgets/order_screen_without_map.dart';
import 'package:foodpanda_user/customize/screens/customize_screen.dart';
import 'package:foodpanda_user/food_delivery/screens/food_delivery_screen.dart';
import 'package:foodpanda_user/home_screen/screens/home_screen.dart';
import 'package:foodpanda_user/order_history/screens/order_history_screen.dart';
import 'package:foodpanda_user/pick_location/screens/pick_location_screen.dart';
import 'package:foodpanda_user/pick_location/screens/search_address_manual_screen.dart';
import 'package:foodpanda_user/search/screens/search_screen.dart';
import 'package:foodpanda_user/shop_details/screens/shop_details.dart';
import 'package:foodpanda_user/voucher/screens/apply_voucher_screen.dart';
import 'package:foodpanda_user/voucher/screens/voucher_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case PickLocationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PickLocationScreen(),
      );

    case ShopDetailScreen.routeName:
      final args = routeSettings.arguments as ShopDetailScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ShopDetailScreen(
          shop: args.shop,
          menu: args.menu,
        ),
      );

    case FoodDeliveryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const FoodDeliveryScreen(),
      );

    case EmailAuthenticationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const EmailAuthenticationScreen(),
      );

    case LoginWithEmailScreen.routeName:
      var email = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginWithEmailScreen(
          email: email,
        ),
      );

    case SendVerificationEmailScreen.routeName:
      var email = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SendVerificationEmailScreen(
          email: email,
        ),
      );

    case FillAccountInfo.routeName:
      var email = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => FillAccountInfo(
          email: email,
        ),
      );

    case PhoneNumberRegisterScreen.routeName:
      // var email = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PhoneNumberRegisterScreen(
            // email: email,
            ),
      );
    case PhoneOTPScreen.routeName:
      var arguments = routeSettings.arguments as Map;
      var verificationId = arguments['verificationId'] as String;
      var phoneNumber = arguments['phoneNumber'] as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => PhoneOTPScreen(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
        ),
      );

    case CustomizeScreen.routeName:
      final args = routeSettings.arguments as CustomizeScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CustomizeScreen(
          sellerName: args.sellerName,
          sellerUid: args.sellerUid,
          categoryId: args.categoryId,
          food: args.food,
          cart: args.cart,
          cartIndex: args.cartIndex,
          shop: args.shop,
        ),
      );

    case CartScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CartScreen(),
      );

    case CheckoutScreen.routeName:
      final args = routeSettings.arguments as CheckoutScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CheckoutScreen(
          carts: args.carts,
          isCutlery: args.isCutlery,
          subtotalPrice: args.subtotalPrice,
          deliveryPrice: args.deliveryPrice,
          discountPrice: args.discountPrice,
          voucherId: args.voucherId,
        ),
      );

    case OrderScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderScreen(),
      );

    case OrderScreenWithoutMap.routeName:
      final args = routeSettings.arguments as OrderScreenWithoutMap;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderScreenWithoutMap(
          order: args.order,
        ),
      );

    case HelpScreen.routeName:
      final args = routeSettings.arguments as HelpScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HelpScreen(
          voucherId: args.voucherId,
        ),
      );

    case AddressScreen.routeName:
      final args = routeSettings.arguments as AddressScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          selectedAddress: args.selectedAddress,
          handleChange: args.handleChange,
          mapController: args.mapController,
        ),
      );

    case EditAddressScreen.routeName:
      final args = routeSettings.arguments as EditAddressScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EditAddressScreen(
          editAddress: args.editAddress,
          isSetLocation: args.isSetLocation,
          isInstructionFocus: args.isInstructionFocus,
          handleChange: args.handleChange,
        ),
      );

    case OrderHistoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderHistoryScreen(),
      );

    case SearchAddressManualScreen.routeName:
      final args = routeSettings.arguments as SearchAddressManualScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchAddressManualScreen(
          getLocation: args.getLocation,
        ),
      );

    case BannerScreen.routeName:
      final args = routeSettings.arguments as BannerScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => BannerScreen(
          banner: args.banner,
        ),
      );

    case VoucherScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const VoucherScreen(),
      );

    case ApplyVoucherScreen.routeName:
      final args = routeSettings.arguments as ApplyVoucherScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ApplyVoucherScreen(
          subtotal: args.subtotal,
          setVoucher: args.setVoucher,
        ),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
