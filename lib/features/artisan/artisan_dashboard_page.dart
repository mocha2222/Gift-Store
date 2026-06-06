import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router/app_router.dart';

class ArtisanDashboardPage extends StatelessWidget {
  const ArtisanDashboardPage({super.key});

  static const Color _backgroundColor = Color(0xFFF7F0E4);
  static const Color _surfaceColor = Color(0xFFFBF5EA);
  static const Color _primaryColor = Color(0xFF8C6500);
  static const Color _textDarkColor = Color(0xFF2C261E);
  static const Color _textMutedColor = Color(0xFF5F564C);

  @override
  Widget build(BuildContext context) {
    const bool hasUnreadMessages = true;

    return Scaffold(
      key: PageStorageKey<String>(AppRoutes.artisanDashboard),
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: _backgroundColor,
            surfaceTintColor: _backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 68,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: CircleAvatar(
                backgroundColor: _primaryColor,
                child: Text(
                  'MA',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(
              'Mekong Artisan Studio',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _textDarkColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _openNotifications(context),
                icon: const Icon(Icons.notifications_outlined),
                color: _primaryColor,
              ),
              IconButton(
                onPressed: () => _openSettings(context),
                icon: const Icon(Icons.settings_outlined),
                color: _primaryColor,
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _HeroPanel(
                onOpenMessages: () => _openChat(context),
                onOpenNotifications: () => _openNotifications(context),
                onOpenSettings: () => _openSettings(context),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _DashboardSection(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.98,
                  children: const [
                    _StatCard(
                      label: 'Total Orders',
                      value: '128',
                      icon: Icons.shopping_bag_outlined,
                      accentColor: Color(0xFFB06B00),
                      subtitle: '18 pending today',
                    ),
                    _StatCard(
                      label: 'Revenue',
                      value: '\$4,320',
                      icon: Icons.attach_money,
                      accentColor: Color(0xFF8D5CC7),
                      subtitle: 'This week +12%',
                    ),
                    _StatCard(
                      label: 'Active Products',
                      value: '34',
                      icon: Icons.inventory_2_outlined,
                      accentColor: Color(0xFF0F8A6C),
                      subtitle: '4 low stock items',
                    ),
                    _StatCard(
                      label: 'Avg Rating',
                      value: '4.8',
                      icon: Icons.star_outline,
                      accentColor: Color(0xFFD08A16),
                      subtitle: '96% positive feedback',
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _DashboardSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: 'Recent Orders',
                      actionLabel: 'See all',
                      onActionTap: () {
                        _openNotifications(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: _primaryColor.withValues(alpha: 0.1),
                      ),
                      itemBuilder: (context, index) {
                        const orders = [
                          _OrderRow(
                            customerName: 'Sothea Meas',
                            productName: 'Hand-woven basket',
                            amount: '\$28.00',
                            status: 'Pending',
                          ),
                          _OrderRow(
                            customerName: 'Lin Wei',
                            productName: 'Ceramic tea set',
                            amount: '\$65.00',
                            status: 'Completed',
                          ),
                          _OrderRow(
                            customerName: 'Dara Pich',
                            productName: 'Silk scarf — indigo',
                            amount: '\$42.00',
                            status: 'Shipped',
                          ),
                          _OrderRow(
                            customerName: 'Amara Sok',
                            productName: 'Rattan wall decor',
                            amount: '\$55.00',
                            status: 'Processing',
                          ),
                        ];

                        return orders[index];
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _DashboardSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(title: 'Quick Actions'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.8,
                      children: [
                        _QuickActionTile(
                          icon: Icons.add_box_outlined,
                          label: 'Add Product',
                          onTap: () {},
                        ),
                        _QuickActionTile(
                          icon: Icons.bar_chart_outlined,
                          label: 'View Revenue',
                          onTap: () {},
                        ),
                        _QuickActionTile(
                          icon: Icons.local_offer_outlined,
                          label: 'Promotions',
                          onTap: () {},
                        ),
                        _QuickActionTile(
                          icon: Icons.chat_bubble_outlined,
                          label: 'Messages',
                          onTap: () => _openChat(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (hasUnreadMessages)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAEEDA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _primaryColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outlined,
                        color: _primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You have 3 unread messages',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textDarkColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _openChat(context),
                        style: TextButton.styleFrom(
                          foregroundColor: _primaryColor,
                        ),
                        child: const Text('Go to chat'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.artisanNotifications);
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.artisanSettings);
  }

  void _openChat(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.artisanChat);
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.onOpenMessages,
    required this.onOpenNotifications,
    required this.onOpenSettings,
  });

  final VoidCallback onOpenMessages;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ArtisanDashboardPage._primaryColor,
            ArtisanDashboardPage._primaryColor.withValues(alpha: 0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ArtisanDashboardPage._primaryColor.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Center(
                  child: Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today at a glance',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Good morning, your artisan shop is active.',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroChip(
                label: '18 new orders',
                icon: Icons.shopping_bag_outlined,
              ),
              _HeroChip(
                label: '3 unread chats',
                icon: Icons.chat_bubble_outline,
              ),
              _HeroChip(label: '2 alerts', icon: Icons.notifications_outlined),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onOpenMessages,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: ArtisanDashboardPage._primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Open chat'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onOpenSettings,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Settings'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onOpenNotifications,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Go to notifications',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSection extends StatelessWidget {
  const _DashboardSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArtisanDashboardPage._surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ArtisanDashboardPage._primaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: ArtisanDashboardPage._textDarkColor,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: ArtisanDashboardPage._primaryColor,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel!,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.subtitle,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, accentColor.withValues(alpha: 0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 19, color: accentColor),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Live',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: ArtisanDashboardPage._textDarkColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: ArtisanDashboardPage._textMutedColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: ArtisanDashboardPage._textMutedColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.customerName,
    required this.productName,
    required this.amount,
    required this.status,
  });

  final String customerName;
  final String productName;
  final String amount;
  final String status;

  @override
  Widget build(BuildContext context) {
    final badge = _StatusBadgeStyle.forStatus(status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ArtisanDashboardPage._primaryColor.withValues(
              alpha: 0.14,
            ),
            child: Text(
              _initials(customerName),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ArtisanDashboardPage._primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ArtisanDashboardPage._textDarkColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  productName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ArtisanDashboardPage._textMutedColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ArtisanDashboardPage._textDarkColor,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: badge.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: badge.textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'A';
    }
    if (parts.length == 1) {
      final word = parts.first;
      return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: ArtisanDashboardPage._surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ArtisanDashboardPage._primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: ArtisanDashboardPage._primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ArtisanDashboardPage._textDarkColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadgeStyle {
  const _StatusBadgeStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;

  static _StatusBadgeStyle forStatus(String status) {
    switch (status) {
      case 'Pending':
        return const _StatusBadgeStyle(
          backgroundColor: Color(0xFFFAEEDA),
          textColor: Color(0xFF854F0B),
        );
      case 'Processing':
        return const _StatusBadgeStyle(
          backgroundColor: Color(0xFFE6F1FB),
          textColor: Color(0xFF185FA5),
        );
      case 'Shipped':
        return const _StatusBadgeStyle(
          backgroundColor: Color(0xFFEEEDFE),
          textColor: Color(0xFF534AB7),
        );
      case 'Completed':
        return const _StatusBadgeStyle(
          backgroundColor: Color(0xFFEAF3DE),
          textColor: Color(0xFF3B6D11),
        );
      case 'Cancelled':
        return const _StatusBadgeStyle(
          backgroundColor: Color(0xFFFCEBEB),
          textColor: Color(0xFFA32D2D),
        );
      default:
        return const _StatusBadgeStyle(
          backgroundColor: Color(0xFFFAEEDA),
          textColor: Color(0xFF854F0B),
        );
    }
  }
}
