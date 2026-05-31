import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool orderUpdates = true;
  bool promoUpdates = true;
  bool artisanStories = false;
  bool appAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
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
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8C6500),
          ),
        ),
        backgroundColor: const Color(0xFFF7F0E4),
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
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
                      color: Colors.white.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Choose what you want to hear about from the store.',
                          style: TextStyle(
                            color: Color(0xFFFFE9C8),
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
            Text(
              'Preferences',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF231408),
              ),
            ),
            const SizedBox(height: 12),
            _SwitchCard(
              icon: Icons.local_shipping_outlined,
              title: 'Order updates',
              subtitle:
                  'Receive status changes for checkout, packing, and delivery.',
              value: orderUpdates,
              onChanged: (value) => setState(() => orderUpdates = value),
            ),
            const SizedBox(height: 12),
            _SwitchCard(
              icon: Icons.local_offer_outlined,
              title: 'Promotions',
              subtitle: 'Get special offers, drops, and seasonal gift ideas.',
              value: promoUpdates,
              onChanged: (value) => setState(() => promoUpdates = value),
            ),
            const SizedBox(height: 12),
            _SwitchCard(
              icon: Icons.campaign_outlined,
              title: 'Artisan stories',
              subtitle:
                  'Hear about new handmade collections and maker stories.',
              value: artisanStories,
              onChanged: (value) => setState(() => artisanStories = value),
            ),
            const SizedBox(height: 12),
            _SwitchCard(
              icon: Icons.notifications_none_rounded,
              title: 'App alerts',
              subtitle:
                  'Display in-app reminders and important account notices.',
              value: appAlerts,
              onChanged: (value) => setState(() => appAlerts = value),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7EC),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE3D3BE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent activity',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8C6500),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _NotificationItem(
                    icon: Icons.check_circle_rounded,
                    title: 'Order confirmed',
                    subtitle:
                        'Your payment was received and your order is being prepared.',
                    time: '2h ago',
                    accentColor: Color(0xFF2D7A4E),
                  ),
                  const SizedBox(height: 12),
                  const _NotificationItem(
                    icon: Icons.favorite_rounded,
                    title: 'New artisan collection',
                    subtitle:
                        'A new batch of handwoven gifts just arrived in the shop.',
                    time: 'Yesterday',
                    accentColor: Color(0xFFB8770D),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  const _SwitchCard({
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAD5A8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF231408),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF5E5244),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFB8770D),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF231408),
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E7E5A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: Color(0xFF5E5244),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
