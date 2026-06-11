import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router/app_router.dart';
import '../../widgets/app_header.dart';
import 'widgets/add_edit_product_sheet.dart';
import 'widgets/artisan_dashboard_section.dart';
import 'widgets/artisan_hero_panel.dart';
import 'widgets/artisan_order_row.dart';
import 'widgets/artisan_stat_card.dart';

class ArtisanDashboardPage extends StatelessWidget {
  const ArtisanDashboardPage({super.key});

  static const Color backgroundColor = Color(0xFFF7F0E4);
  static const Color surfaceColor = Color(0xFFFBF5EA);
  static const Color primaryColor = Color(0xFF8C6500);
  static const Color textDarkColor = Color(0xFF2C261E);
  static const Color textMutedColor = Color(0xFF5F564C);

  @override
  Widget build(BuildContext context) {
    const bool hasUnreadMessages = true;

    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: ArtisanHeroPanel(
                      onOpenMessages: () => _openChat(context),
                      onOpenNotifications: () => _openNotifications(context),
                      onManageProduct: () => _openArtisanPage(context),
                    ),
                  ),
                ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
                children: const [
                  ArtisanStatCard(
                    label: 'Total Orders',
                    value: '128',
                    icon: Icons.shopping_bag_outlined,
                    accentColor: Color(0xFF5B7FA6),
                    subtitle: '18 pending today',
                  ),
                  ArtisanStatCard(
                    label: 'Revenue',
                    value: '\$4,320',
                    icon: Icons.attach_money_rounded,
                    accentColor: Color(0xFF6B4C9A),
                    subtitle: 'This week +12%',
                  ),
                  ArtisanStatCard(
                    label: 'Total Products',
                    value: '34',
                    icon: Icons.inventory_2_outlined,
                    accentColor: Color(0xFF4A7C59),
                    subtitle: '4 low stock items',
                  ),
                  ArtisanStatCard(
                    label: 'Avg Rating',
                    value: '4.8',
                    icon: Icons.star_outline_rounded,
                    accentColor: Color(0xFFB8770D),
                    subtitle: '96% positive feedback',
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArtisanSectionHeader(
                    title: 'Recent Orders',
                    actionLabel: 'See all',
                    onActionTap: () {
                      _openNotifications(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  ArtisanDashboardSection(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (_, __) => const Divider(
                        height: 16,
                        color: Color(0xFFE2D3BE),
                      ),
                      itemBuilder: (context, index) {
                        const orders = [
                          ArtisanOrderRow(
                            customerName: 'Sothea Meas',
                            productName: 'Hand-woven basket',
                            amount: '\$28.00',
                            status: 'Pending',
                          ),
                          ArtisanOrderRow(
                            customerName: 'Lin Wei',
                            productName: 'Ceramic tea set',
                            amount: '\$65.00',
                            status: 'Completed',
                          ),
                          ArtisanOrderRow(
                            customerName: 'Dara Pich',
                            productName: 'Silk scarf — indigo',
                            amount: '\$42.00',
                            status: 'Shipped',
                          ),
                          ArtisanOrderRow(
                            customerName: 'Amara Sok',
                            productName: 'Rattan wall decor',
                            amount: '\$55.00',
                            status: 'Processing',
                          ),
                        ];

                        return orders[index];
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ArtisanSectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 8),
                  ArtisanDashboardSection(
                    child: Column(
                      children: [
                        _QuickActionRow(
                          icon: Icons.add_box_outlined,
                          label: 'Add Product',
                          onTap: () => _addProduct(context),
                        ),
                        const Divider(color: Color(0xFFE2D3BE), height: 16),
                        _QuickActionRow(
                          icon: Icons.bar_chart_outlined,
                          label: 'View Revenue',
                          onTap: () {},
                        ),
                        const Divider(color: Color(0xFFE2D3BE), height: 16),
                        _QuickActionRow(
                          icon: Icons.local_offer_outlined,
                          label: 'Promotions',
                          onTap: () {},
                        ),
                        const Divider(color: Color(0xFFE2D3BE), height: 16),
                        _QuickActionRow(
                          icon: Icons.chat_bubble_outlined,
                          label: 'Messages',
                          onTap: () => _openChat(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasUnreadMessages)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7EC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2D3BE),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: primaryColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Keep your chats updated with customers',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textDarkColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _openChat(context),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                        ),
                        child: Text(
                          'Go to Chat',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
              ],
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

  void _openArtisanPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.artisan);
  }

  void _addProduct(BuildContext context) {
    AddEditProductSheet.show(context);
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF8C6500).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: const Color(0xFF8C6500),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C261E),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9E7E5A),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
