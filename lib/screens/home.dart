import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../features/home/widgets/home_footer_nav.dart';
import '../features/home/widgets/home_header.dart';
import '../features/home/widgets/home_homepage.dart';

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
    return const Scaffold(
      body: Column(
        children: [
          HomeHeader(),
          Expanded(child: HomeHomepage()),
          SafeArea(top: false, child: HomeFooterNav()),
        ],
      ),
    );
  }
}
