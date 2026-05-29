import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/login_page.dart';
import 'features/home/home_page.dart';
=======
import 'screens/home.dart';
>>>>>>> 5ee24125197ad5cf24fba61a909209004fa091e4

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs      = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getString('user_email') != null;
  runApp(GiftShopApp(isLoggedIn: isLoggedIn));
}
<<<<<<< HEAD

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
=======
>>>>>>> 5ee24125197ad5cf24fba61a909209004fa091e4
