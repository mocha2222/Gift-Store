
import 'package:flutter/material.dart';

import '../data/home_mock_data.dart';
import '../features/auth/login_page.dart';
import '../features/auth/signup_page.dart';
import '../features/detail/product_detail_page.dart';
import '../features/home/home_page.dart';
import '../features/quiz/quiz_page.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const quiz = '/quiz';
  static const productDetail = '/product-detail';
}

class ProductDetailArgs {
  const ProductDetailArgs({required this.item});

  final GiftItem item;
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage(), settings: settings);
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage(), settings: settings);
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const GiftShopShell(), settings: settings);
      case AppRoutes.quiz:
        return MaterialPageRoute(builder: (_) => const QuizPage(), settings: settings);
      case AppRoutes.productDetail:
        final args = settings.arguments;
        if (args is ProductDetailArgs) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailPage(item: args.item),
            settings: settings,
          );
        }
        return _errorRoute('Product detail needs a GiftItem argument.');
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
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
