import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/login_page.dart';
import '../router/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF7F0E4),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: 112,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Khmer Treasures',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Discover handcrafted gifts and stories',
                          style: TextStyle(
                            color: Color(0xFFFFE8C7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.explore_outlined,
                    label: 'Explore',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Category',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.collections_bookmark_outlined,
                    label: 'Collection',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Favorites',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.location_on_outlined,
                    label: 'Nearby',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.quiz_outlined,
                    label: 'Quiz Challenge',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.quiz);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _DrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('user_email');
                      await prefs.remove('user_password');
                      if (!context.mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                final email = snapshot.data?.getString('user_email');
                final displayEmail = email == null || email.isEmpty
                    ? 'Guest account'
                    : email;
                final initials = _buildInitials(displayEmail);

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7EC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE3D3BE)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: const Color(0xFFD8AE73),
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Color(0xFF4A321B),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Profile',
                                style: TextStyle(
                                  color: Color(0xFF9E7E5A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                displayEmail,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF231408),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'Tap the menu to explore your account',
                                style: TextStyle(
                                  color: Color(0xFF8B6F52),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String _buildInitials(String value) {
  final parts = value.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
  final firstPart = parts.isNotEmpty ? parts.first : 'G';
  final secondPart = parts.length > 1 ? parts[1] : '';
  final firstInitial = firstPart.isNotEmpty ? firstPart[0].toUpperCase() : 'G';
  final secondInitial = secondPart.isNotEmpty ? secondPart[0].toUpperCase() : '';
  return '$firstInitial$secondInitial';
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: const Color(0xFF8C6500)),
      title: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF231408),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}


