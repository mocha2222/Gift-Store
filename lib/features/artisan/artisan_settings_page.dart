import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router/app_router.dart';

class ArtisanSettingsPage extends StatefulWidget {
  const ArtisanSettingsPage({super.key});

  @override
  State<ArtisanSettingsPage> createState() => _ArtisanSettingsPageState();
}

class _ArtisanSettingsPageState extends State<ArtisanSettingsPage> {
  static const Color _backgroundColor = Color(0xFFF7F0E4);
  static const Color _primaryColor = Color(0xFF8C6500);

  bool _shopOpen = true;
  bool _customOrders = true;
  bool _autoReply = false;
  bool _inventorySync = true;

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
          'Settings',
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primaryColor,
                    _primaryColor.withValues(alpha: 0.88),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shop preferences',
                          style: GoogleFonts.cormorantGaramond(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tune your shop visibility, message behavior, and sync options.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFFE9C8),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Shop status',
              child: Column(
                children: [
                  _SettingsSwitch(
                    icon: Icons.storefront_outlined,
                    title: 'Open shop',
                    subtitle: 'Make your storefront visible to customers.',
                    value: _shopOpen,
                    onChanged: (value) => setState(() => _shopOpen = value),
                  ),
                  const SizedBox(height: 10),
                  _SettingsSwitch(
                    icon: Icons.edit_note_outlined,
                    title: 'Accept custom orders',
                    subtitle: 'Allow buyers to request personalized items.',
                    value: _customOrders,
                    onChanged: (value) => setState(() => _customOrders = value),
                  ),
                  const SizedBox(height: 10),
                  _SettingsSwitch(
                    icon: Icons.message_outlined,
                    title: 'Auto reply',
                    subtitle: 'Send a friendly message when you are away.',
                    value: _autoReply,
                    onChanged: (value) => setState(() => _autoReply = value),
                  ),
                  const SizedBox(height: 10),
                  _SettingsSwitch(
                    icon: Icons.sync_outlined,
                    title: 'Inventory sync',
                    subtitle: 'Keep your product stock updated in real time.',
                    value: _inventorySync,
                    onChanged: (value) =>
                        setState(() => _inventorySync = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Account & tools',
              child: Column(
                children: [
                  _ActionTile(
                    icon: Icons.person_outline,
                    title: 'Edit artisan profile',
                    subtitle: 'Change your display name, photo, and shop bio.',
                  ),
                  SizedBox(height: 10),
                  _ActionTile(
                    icon: Icons.payments_outlined,
                    title: 'Payment methods',
                    subtitle: 'Manage payout accounts and billing details.',
                  ),
                  SizedBox(height: 10),
                  _ActionTile(
                    icon: Icons.language_outlined,
                    title: 'Language & region',
                    subtitle: 'Set the language and currency for your shop.',
                  ),
                  SizedBox(height: 10),
                  _ActionTile(
                    icon: Icons.help_outline,
                    title: 'Help & support',
                    subtitle: 'Read guides or contact support from the app.',
                  ),
                  const SizedBox(height: 10),
                  _ActionTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Us',
                    subtitle: 'Learn more about the application.',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.aboutUs);
                    },
                  ),
                  const SizedBox(height: 10),
                  _ActionTile(
                    icon: Icons.logout_rounded,
                    title: 'Sign out',
                    subtitle:
                        'Leave the artisan dashboard and return to login.',
                    isDestructive: true,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.artisanSignOut);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved.')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _ArtisanSettingsColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _ArtisanSettingsColors.primary.withValues(alpha: 0.14),
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
              color: _ArtisanSettingsColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAD5A8)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _ArtisanSettingsColors.primary.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: _ArtisanSettingsColors.primary, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _ArtisanSettingsColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
                    color: _ArtisanSettingsColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              switchTheme: SwitchThemeData(
                thumbColor: WidgetStatePropertyAll(
                  _ArtisanSettingsColors.primary,
                ),
              ),
            ),
            child: Switch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive
        ? const Color(0xFF9A2F2F)
        : _ArtisanSettingsColors.textDark;
    final iconColor = isDestructive
        ? const Color(0xFF9A2F2F)
        : _ArtisanSettingsColors.primary;
    final backgroundColor = isDestructive
        ? const Color(0xFFFDEFEF)
        : const Color(0xFFFFF7EC);
    final borderColor = isDestructive
        ? const Color(0xFFF0C2C2)
        : const Color(0xFFE3D3BE);

    final content = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: iconColor, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
                    color: _ArtisanSettingsColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: _ArtisanSettingsColors.textMuted,
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: content,
      ),
    );
  }
}

class _ArtisanSettingsColors {
  static const Color primary = Color(0xFF8C6500);
  static const Color surface = Color(0xFFFBF5EA);
  static const Color textDark = Color(0xFF2C261E);
  static const Color textMuted = Color(0xFF5F564C);
}
