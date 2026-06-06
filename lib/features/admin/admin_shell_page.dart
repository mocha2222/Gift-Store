import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../router/app_router.dart';
import 'artisan_management_page.dart';
import 'dashboard_page.dart';
import 'order_management_page.dart';
import 'product_management_page.dart';

class AdminShellPage extends StatefulWidget {
  const AdminShellPage({super.key});

  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  static const List<String> _titles = [
    'Dashboard Overview',
    'Artisan Management',
    'Product Management',
    'Order Management',
  ];

  final List<Widget> _pages = const [
    AdminDashboardPage(),
    ArtisanManagementPage(),
    ProductManagementPage(),
    OrderManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 980;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F0E4),
      drawer: isWide
          ? null
          : Drawer(
              child: _AdminDrawer(
                currentIndex: _index,
                onChanged: (value) {
                  Navigator.of(context).pop();
                  setState(() => _index = value);
                },
              ),
            ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              backgroundColor: const Color(0xFFFFF7EC),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront_rounded),
                  label: 'Artisans',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: 'Products',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders',
                ),
              ],
            ),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              _AdminRail(
                currentIndex: _index,
                onChanged: (value) => setState(() => _index = value),
              ),
            Expanded(
              child: Column(
                children: [
                  _AdminTopBar(
                    title: _titles[_index],
                    onMenuTap: isWide ? null : () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  Expanded(child: _pages[_index]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer({required this.currentIndex, required this.onChanged});

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F2937), Color(0xFF8C6500)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 36),
              SizedBox(height: 12),
              Text(
                'Gift Shop Admin',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 6),
              Text(
                'Manage artisans, products, orders, and revenue',
                style: TextStyle(color: Color(0xFFFFE8C7), fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _DrawerTile(
          icon: Icons.dashboard_outlined,
          label: 'Dashboard',
          selected: currentIndex == 0,
          onTap: () => onChanged(0),
        ),
        _DrawerTile(
          icon: Icons.storefront_outlined,
          label: 'Artisan Management',
          selected: currentIndex == 1,
          onTap: () => onChanged(1),
        ),
        _DrawerTile(
          icon: Icons.inventory_2_outlined,
          label: 'Product Management',
          selected: currentIndex == 2,
          onTap: () => onChanged(2),
        ),
        _DrawerTile(
          icon: Icons.receipt_long_outlined,
          label: 'Order Management',
          selected: currentIndex == 3,
          onTap: () => onChanged(3),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: Color(0xFFE2D3BE), indent: 12, endIndent: 12),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            leading: const Icon(Icons.logout, color: Color(0xFFC0392B)),
            title: const Text('Sign Out', style: TextStyle(color: Color(0xFFC0392B), fontWeight: FontWeight.w600)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
          ),
        ),
      ],
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        selected: selected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, color: selected ? const Color(0xFF8C6500) : const Color(0xFF4B5563)),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}

class _AdminRail extends StatelessWidget {
  const _AdminRail({required this.currentIndex, required this.onChanged});

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF7EC),
        border: Border(right: BorderSide(color: Color(0xFFE2D3BE))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 34),
                SizedBox(height: 10),
                Text(
                  'Gift Shop Admin',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  'Operational overview',
                  style: TextStyle(color: Color(0xFFFFF1D6), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _RailButton(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            selected: currentIndex == 0,
            onTap: () => onChanged(0),
          ),
          _RailButton(
            icon: Icons.storefront_outlined,
            label: 'Artisans',
            selected: currentIndex == 1,
            onTap: () => onChanged(1),
          ),
          _RailButton(
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            selected: currentIndex == 2,
            onTap: () => onChanged(2),
          ),
          _RailButton(
            icon: Icons.receipt_long_outlined,
            label: 'Orders',
            selected: currentIndex == 3,
            onTap: () => onChanged(3),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (context.mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Color(0xFFC0392B)),
                      SizedBox(width: 12),
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Color(0xFFC0392B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'This area mirrors the backend collections exposed in the API.',
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Material(
        color: selected ? const Color(0xFFF1E7D5) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: selected ? const Color(0xFF8C6500) : const Color(0xFF9E7E5A)),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? const Color(0xFF231408) : const Color(0xFF5F564C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminTopBar extends StatefulWidget {
  const _AdminTopBar({required this.title, this.onMenuTap});

  final String title;
  final VoidCallback? onMenuTap;

  @override
  State<_AdminTopBar> createState() => _AdminTopBarState();
}

class _AdminTopBarState extends State<_AdminTopBar> {
  String _email = 'admin@test.com';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('user_email') ?? 'admin@test.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC).withValues(alpha: 0.95),
        border: const Border(bottom: BorderSide(color: Color(0xFFE2D3BE))),
      ),
      child: Row(
        children: [
          if (widget.onMenuTap != null)
            IconButton(
              onPressed: widget.onMenuTap,
              icon: const Icon(Icons.menu_rounded),
            ),
          Expanded(
            child: Text(
              widget.title,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF231408),
              ),
            ),
          ),
          const _TopBarChip(
            icon: Icons.notifications_none_rounded,
            label: '3 alerts',
          ),
          const SizedBox(width: 10),
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            tooltip: 'Account',
            onSelected: (value) async {
              if (value == 'logout') {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (context.mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(_email, style: const TextStyle(color: Colors.black54)),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18, color: Color(0xFFC0392B)),
                    SizedBox(width: 8),
                    Text('Sign Out', style: TextStyle(color: Color(0xFFC0392B), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF8C6500),
              child: Text(_email.isNotEmpty ? _email[0].toUpperCase() : 'A', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarChip extends StatelessWidget {
  const _TopBarChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2D3BE)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8C6500)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF6B4C2F)),
          ),
        ],
      ),
    );
  }
}
