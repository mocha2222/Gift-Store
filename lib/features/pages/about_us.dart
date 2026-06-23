import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../router/app_router.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              }
            },
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
          'About Us',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8C6500),
          ),
        ),
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo or Icon Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8C6500).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.redeem_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Gift-Store',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF231408),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF9E7E5A),
              ),
            ),
            const SizedBox(height: 32),

            // Description Section
            _SectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Story',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8C6500),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome to Gift-Store, the premier destination for discovering beautiful, handcrafted, and personalized gifts. We connect talented artisans with people looking for that perfect, meaningful present for their loved ones.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF5E5244),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Our platform was built with a vision to support independent creators and make gifting an unforgettable experience.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF5E5244),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Connect With Us Section
            _SectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect With Us',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8C6500),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SocialLinkTile(
                    icon: Icons.language_rounded,
                    title: 'Website',
                    subtitle: 'www.gift-store.example.com',
                  ),
                  const SizedBox(height: 12),
                  _SocialLinkTile(
                    icon: Icons.email_outlined,
                    title: 'Support',
                    subtitle: 'support@gift-store.example.com',
                  ),
                  const SizedBox(height: 12),
                  _SocialLinkTile(
                    icon: Icons.camera_alt_outlined,
                    title: 'Instagram',
                    subtitle: '@giftstore_app',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Footer
            Text(
              'Made with ♥ by the Gift-Store Team',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF9E7E5A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© ${DateTime.now().year} Gift-Store. All rights reserved.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF9E7E5A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAD5A8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF231408).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SocialLinkTile extends StatelessWidget {
  const _SocialLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7EC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE3D3BE)),
          ),
          child: Icon(icon, color: const Color(0xFF8C6500), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF231408),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF5E5244),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
