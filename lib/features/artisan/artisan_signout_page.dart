import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../router/app_router.dart';

class ArtisanSignOutPage extends StatefulWidget {
  const ArtisanSignOutPage({super.key});

  @override
  State<ArtisanSignOutPage> createState() => _ArtisanSignOutPageState();
}

class _ArtisanSignOutPageState extends State<ArtisanSignOutPage> {
  static const Color _backgroundColor = Color(0xFFF7F0E4);
  static const Color _primaryColor = Color(0xFF8C6500);

  bool _isSigningOut = false;

  Future<void> _signOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_initials');
    await prefs.remove('user_joined');
    await prefs.remove('user_avatar_path');
    await prefs.remove('user_avatar_bytes');
    await prefs.remove('user_password');
    await prefs.remove('followed_artisans');
    await prefs.remove('favorite_products');
    await prefs.remove('cart_items');

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAD5A8)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF231408),
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'Sign Out',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _primaryColor,
          ),
        ),
        backgroundColor: _backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF231408),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _primaryColor,
                      _primaryColor.withValues(alpha: 0.88),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.16),
                      blurRadius: 26,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Leave your artisan session?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your shop data stays safe. You can sign back in any time to continue managing orders, chats, and settings.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFE9C8),
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _InfoCard(
                title: 'What happens next',
                child: Column(
                  children: const [
                    _InfoRow(
                      icon: Icons.lock_reset_rounded,
                      text:
                          'Your saved session will be cleared from this device.',
                    ),
                    SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.chat_bubble_outline,
                      text: 'Unread chat and dashboard data stay in place.',
                    ),
                    SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.replay_rounded,
                      text: 'You can return to the login screen with one tap.',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSigningOut
                          ? null
                          : () => Navigator.of(context).maybePop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: const BorderSide(color: Color(0xFFE3D3BE)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSigningOut ? null : _signOut,
                      style: FilledButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isSigningOut
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Sign out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _ArtisanSignOutColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _ArtisanSignOutColors.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _ArtisanSignOutColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _ArtisanSignOutColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: _ArtisanSignOutColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.45,
                color: _ArtisanSignOutColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArtisanSignOutColors {
  static const Color primary = Color(0xFF8C6500);
  static const Color surface = Color(0xFFFBF5EA);
  static const Color textDark = Color(0xFF2C261E);
}
