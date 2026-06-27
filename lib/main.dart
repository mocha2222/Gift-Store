import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router/app_router.dart';
import 'services/cart_service.dart';
import 'features/favorites/widgets/favorite_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getString('user_email') != null;
  final role = prefs.getString('user_role') ?? 'customer';
  
  String startRoute = AppRoutes.login;
  if (isLoggedIn) {
    if (role == 'admin') {
      startRoute = AppRoutes.admin;
    } else if (role == 'artisan') {
      startRoute = AppRoutes.artisan;
    } else {
      startRoute = AppRoutes.home;
    }
  }

  final cartService = CartService();
  final favoriteNotifier = FavoriteNotifier();

  // If logged in, fetch cart and favorites from backend
  if (isLoggedIn) {
    cartService.loadFromBackend();
    favoriteNotifier.loadFromBackend();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cartService),
        ChangeNotifierProvider.value(value: favoriteNotifier),
      ],
      child: GiftShopApp(initialRoute: startRoute),
    ),
  );
}

class GiftShopApp extends StatelessWidget {
  final String initialRoute;
  const GiftShopApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return FavoriteProvider(
      notifier: Provider.of<FavoriteNotifier>(context, listen: false),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8C6500)),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
