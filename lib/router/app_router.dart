import 'package:flutter/material.dart';

import '../data/home_mock_data.dart';
import '../features/auth/login_page.dart';
import '../features/auth/signup_page.dart';
import '../features/admin/admin_shell_page.dart';
import '../features/artisan/artisan_shell_page.dart';
import '../features/detail/product_detail_page.dart';
import '../features/home/home_page.dart';
import '../features/quiz/quiz_page.dart';
import '../features/map/map_page.dart';
import '../pages/cart_page.dart';
import '../pages/checkout_page.dart';
import '../pages/product_review_page.dart';
import '../pages/booking_flow.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const quiz = '/quiz';
  static const productDetail = '/product-detail';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const productReview = '/product-review';
  static const bookingFlow = '/booking-flow';
  static const admin = '/admin';
  static const map = '/map';
  static const artisan = '/artisan';
}

class ProductDetailArgs {
  const ProductDetailArgs({required this.item});

  final GiftItem item;
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => const SignupPage(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const GiftShopShell(),
          settings: settings,
        );
      case AppRoutes.quiz:
        return MaterialPageRoute(
          builder: (_) => const QuizPage(),
          settings: settings,
        );
      case AppRoutes.productDetail:
        final args = settings.arguments;
        if (args is ProductDetailArgs) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailPage(item: args.item),
            settings: settings,
          );
        }
        return _errorRoute('Product detail needs a GiftItem argument.');
      case AppRoutes.cart:
        return MaterialPageRoute(
          builder: (_) => const CartPage(),
          settings: settings,
        );
      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => const CheckoutPage(),
          settings: settings,
        );
      case AppRoutes.productReview:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          final id = args['productId'] as String?;
          final title = args['productTitle'] as String? ?? '';
          if (id != null) {
            return MaterialPageRoute(
              builder: (_) =>
                  ProductReviewPage(productId: id, productTitle: title),
              settings: settings,
            );
          }
        }
        return _errorRoute(
          'Product review needs productId and optional productTitle.',
        );
      case AppRoutes.bookingFlow:
        return MaterialPageRoute(
          builder: (_) => const BookingFlowPage(),
          settings: settings,
        );
      case AppRoutes.admin:
        return MaterialPageRoute(
          builder: (_) => const AdminShellPage(),
          settings: settings,
        );
      case AppRoutes.artisan:
        return MaterialPageRoute(
          builder: (_) => const ArtisanShellPage(),
          settings: settings,
        );
      case AppRoutes.map:
        return MaterialPageRoute(
          builder: (_) => const MapPage(),
          settings: settings,
        );
      default:
        return _errorRoute('No route defined for ${settings.name}.');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
