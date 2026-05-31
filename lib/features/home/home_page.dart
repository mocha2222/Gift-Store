import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../quiz/quiz_page.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_footer_nav.dart';
import '../../widgets/app_header.dart';
import 'widgets/home_homepage.dart';

class GiftShopApp extends StatelessWidget {
  const GiftShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const GiftShopShell(),
    );
  }
}

class GiftShopShell extends StatelessWidget {
  const GiftShopShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: const Column(
        children: [
          AppHeader(),
          Expanded(child: HomeHomepage()),
          SafeArea(top: false, child: AppFooterNav()),
        ],
      ),
    );
  }
}

