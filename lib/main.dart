import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs      = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getString('user_email') != null;
  runApp(GiftShopApp(isLoggedIn: isLoggedIn));
}

class GiftShopApp extends StatelessWidget {
  final bool isLoggedIn;
  const GiftShopApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      initialRoute: AppRoutes.artisanDashboard, //test without login
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
