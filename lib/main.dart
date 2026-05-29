import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/login_page.dart';
import 'features/home/home_page.dart';

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
      // Use your leader's existing theme — don't change this line
      // theme: AppTheme.theme(),
      home: isLoggedIn ? const GiftShopShell() : const LoginPage(),
    );
  }
}