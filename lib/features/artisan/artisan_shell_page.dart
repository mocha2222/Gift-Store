import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../router/app_router.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_header.dart';
import 'artisan_dashboard_page.dart';
import 'artisan_products_page.dart';
import '../orders/artisan_orders_page.dart';
import '../chat/artisan_chat_page.dart';

class ArtisanShellPage extends StatefulWidget {
  const ArtisanShellPage({super.key});

  @override
  State<ArtisanShellPage> createState() => _ArtisanShellPageState();
}

class _ArtisanShellPageState extends State<ArtisanShellPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role');
    final token = prefs.getString('access_token');
    
    if (token == null || role != 'artisan') {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
      return;
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  final List<Widget> _pages = const [
    ArtisanDashboardPage(),
    ArtisanProductsPage(),
    ArtisanOrdersPage(),
    ArtisanChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFBF6EE),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFBF6EE),
      drawer: const AppDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: const Color(0xFFFFF7EC),
        indicatorColor: const Color(0xFFF1E7D5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF8C6500)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded, color: Color(0xFF8C6500)),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag_rounded, color: Color(0xFF8C6500)),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat_rounded, color: Color(0xFF8C6500)),
            label: 'Chat',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_index != 2)
              AppHeader(
                showCart: false,
                actions: [
                  HeaderIconButton(
                    icon: Icons.notifications_outlined,
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.artisanNotifications),
                  ),
                  HeaderIconButton(
                    icon: Icons.settings_outlined,
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.artisanSettings),
                  ),
                ],
              ),
            Expanded(child: _pages[_index]),
          ],
        ),
      ),
    );
  }
}