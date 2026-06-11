import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArtisanNotificationsPage extends StatefulWidget {
  const ArtisanNotificationsPage({super.key});

  @override
  State<ArtisanNotificationsPage> createState() =>
      _ArtisanNotificationsPageState();
}

class _ArtisanNotificationsPageState extends State<ArtisanNotificationsPage> {
  static const Color _backgroundColor = Color(0xFFF7F0E4);
  static const Color _surfaceColor = Color(0xFFFBF5EA);
  static const Color _primaryColor = Color(0xFF8C6500);
  static const Color _textDarkColor = Color(0xFF2C261E);
  static const Color _textMutedColor = Color(0xFF5F564C);

  String _filter = 'All';
  bool _orderAlerts = true;
  bool _chatAlerts = true;
  bool _stockAlerts = false;

  final List<_NotificationEntry> _items = const [
    _NotificationEntry(
      title: 'New order received',
      message: 'A customer just ordered a hand-woven basket.',
      time: '5 min ago',
      filter: 'Orders',
      icon: Icons.shopping_bag_outlined,
    ),
    _NotificationEntry(
      title: 'Unread chat message',
      message: 'Sokha asked if the rattan wall decor can ship this week.',
      time: '24 min ago',
      filter: 'Messages',
      icon: Icons.chat_bubble_outlined,
    ),
    _NotificationEntry(
      title: 'Stock running low',
      message: 'Your silk scarf inventory is down to 4 pieces.',
      time: '1h ago',
      filter: 'Updates',
      icon: Icons.inventory_2_outlined,
    ),
    _NotificationEntry(
      title: 'Order completed',
      message: 'Lin Wei confirmed delivery and left a 5-star rating.',
      time: 'Yesterday',
      filter: 'Orders',
      icon: Icons.check_circle_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final notifications = _items
        .where((item) => _filter == 'All' || item.filter == _filter)
        .toList();

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
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _primaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read.'),
                ),
              );
            },
            child: Text(
              'Mark all read',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: _primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
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
                      Icons.notifications_active_outlined,
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
                          'Notification center',
                          style: GoogleFonts.cormorantGaramond(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Keep track of orders, messages, and shop activity.',
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
            Text(
              'Filters',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _textDarkColor,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['All', 'Orders', 'Messages', 'Updates'].map((filter) {
                final isSelected = filter == _filter;
                return ChoiceChip(
                  selected: isSelected,
                  label: Text(filter),
                  selectedColor: const Color(0xFFFAEEDA),
                  backgroundColor: _surfaceColor,
                  labelStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? _primaryColor : _textMutedColor,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? _primaryColor.withValues(alpha: 0.35)
                        : _primaryColor.withValues(alpha: 0.12),
                  ),
                  onSelected: (_) => setState(() => _filter = filter),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Recent activity',
              child: notifications.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Text(
                        'No notifications in this filter.',
                        style: GoogleFonts.inter(color: _textMutedColor),
                      ),
                    )
                  : Column(
                      children: notifications
                          .map(
                            (notification) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _NotificationCard(entry: notification),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Notification preferences',
              child: Column(
                children: [
                  _PreferenceSwitch(
                    icon: Icons.local_shipping_outlined,
                    title: 'Order alerts',
                    subtitle:
                        'Receive updates when customer orders change status.',
                    value: _orderAlerts,
                    onChanged: (value) => setState(() => _orderAlerts = value),
                  ),
                  const SizedBox(height: 10),
                  _PreferenceSwitch(
                    icon: Icons.chat_bubble_outline,
                    title: 'Chat alerts',
                    subtitle: 'Get notified when customers message your shop.',
                    value: _chatAlerts,
                    onChanged: (value) => setState(() => _chatAlerts = value),
                  ),
                  const SizedBox(height: 10),
                  _PreferenceSwitch(
                    icon: Icons.inventory_2_outlined,
                    title: 'Stock alerts',
                    subtitle: 'Know when products are running low.',
                    value: _stockAlerts,
                    onChanged: (value) => setState(() => _stockAlerts = value),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _ArtisanColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _ArtisanColors.primary.withValues(alpha: 0.14),
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
              color: _ArtisanColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.entry});

  final _NotificationEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAD5A8)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFAEEDA),
              shape: BoxShape.circle,
              border: Border.all(
                color: _ArtisanColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(entry.icon, color: _ArtisanColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _ArtisanColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.message,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.45,
                    color: _ArtisanColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            entry.time,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _ArtisanColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  const _PreferenceSwitch({
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
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3D3BE)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _ArtisanColors.primary.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: _ArtisanColors.primary, size: 21),
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
                    color: _ArtisanColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
                    color: _ArtisanColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              switchTheme: SwitchThemeData(
                thumbColor: WidgetStatePropertyAll(_ArtisanColors.primary),
              ),
            ),
            child: Switch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

class _NotificationEntry {
  const _NotificationEntry({
    required this.title,
    required this.message,
    required this.time,
    required this.filter,
    required this.icon,
  });

  final String title;
  final String message;
  final String time;
  final String filter;
  final IconData icon;
}

class _ArtisanColors {
  static const Color primary = Color(0xFF8C6500);
  static const Color surface = Color(0xFFFBF5EA);
  static const Color textDark = Color(0xFF2C261E);
  static const Color textMuted = Color(0xFF5F564C);
}
