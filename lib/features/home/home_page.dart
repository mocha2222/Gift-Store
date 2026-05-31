import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_page.dart';
import '../quiz/quiz_page.dart';
import '../profile/profile_page.dart';
import '../profile/widgets/profile_avatar.dart';
import '../../theme/app_theme.dart';
import 'widgets/home_footer_nav.dart';
import 'widgets/home_header.dart';
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
      drawer: Drawer(
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
                      icon: Icons.person_outline_rounded,
                      label: 'Profile',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(showAppBar: true),
                          ),
                        );
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.quiz_outlined,
                      label: 'Quiz Challenge',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const QuizPage()),
                        );
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('user_email');
                        await prefs.remove('user_password');
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
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
                  final prefs = snapshot.data;
                  final name = prefs?.getString('user_name') ?? 'Guest';
                  final email = prefs?.getString('user_email') ?? '';
                  final initials =
                      prefs?.getString('user_initials') ??
                      _buildInitials(name.isEmpty ? 'Guest' : name);

                  File? localImage;
                  Uint8List? imageBytes;

                  if (prefs != null) {
                    if (kIsWeb) {
                      final base64Str = prefs.getString('user_avatar_bytes');
                      if (base64Str != null && base64Str.isNotEmpty) {
                        imageBytes = base64Decode(base64Str);
                      }
                    } else {
                      final avatarPath = prefs.getString('user_avatar_path');
                      if (avatarPath != null && avatarPath.isNotEmpty) {
                        final file = File(avatarPath);
                        if (file.existsSync()) {
                          localImage = file;
                        }
                      }
                    }
                  }

                  final displayEmail = email.isEmpty ? 'Guest account' : email;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ProfilePage(showAppBar: true),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7EC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE3D3BE)),
                          ),
                          child: Row(
                            children: [
                              ProfileAvatar(
                                initials: initials,
                                localFile: kIsWeb ? null : localImage,
                                imageBytes: kIsWeb ? imageBytes : null,
                                radius: 21,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Color(0xFF9E7E5A),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      name.isEmpty ? displayEmail : name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF231408),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      displayEmail,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
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
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: const Column(
        children: [
          HomeHeader(),
          Expanded(child: HomeHomepage()),
          SafeArea(top: false, child: HomeFooterNav()),
        ],
      ),
    );
  }
}

String _buildInitials(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty);
  final firstPart = parts.isNotEmpty ? parts.first : 'G';
  final secondPart = parts.length > 1 ? parts.elementAt(1) : '';

  final firstInitial = firstPart.characters.first.toUpperCase();
  final secondInitial = secondPart.isNotEmpty
      ? secondPart.characters.first.toUpperCase()
      : '';
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
