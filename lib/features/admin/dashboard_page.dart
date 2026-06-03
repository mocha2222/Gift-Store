import 'package:flutter/material.dart';

import '../../widgets/app_section_header.dart';
import '../profile/widgets/profile_stats_row.dart';
import 'widgets/dashboard_widgets.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeroPanel(),
          const SizedBox(height: 18),
          AppSectionHeader(
            title: 'Quick Stats',
            actionLabel: 'Refresh',
            onActionTap: () {},
          ),
          const SizedBox(height: 10),
          const ProfileStatsRow(
            stats: [
              (label: 'Revenue', value: '\$18,640.75'),
              (label: 'Orders', value: '248'),
              (label: 'Artisans', value: '42'),
              (label: 'Customers', value: '1,118'),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: const [
              DashboardActionTile(
                title: 'Artisan pipeline',
                subtitle: 'Track pending setup and suspended accounts.',
                icon: Icons.manage_accounts_outlined,
              ),
              DashboardActionTile(
                title: 'Product moderation',
                subtitle: 'Review new products and remove low quality items.',
                icon: Icons.inventory_2_outlined,
              ),
              DashboardActionTile(
                title: 'Order operations',
                subtitle: 'Move orders through confirmed, shipped, and delivered.',
                icon: Icons.local_shipping_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
