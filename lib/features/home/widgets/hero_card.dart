import 'package:flutter/material.dart';

import '../../../router/app_router.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 360,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFF0E1C7)),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x33000000), Color(0xCC000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8AE73).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFD8AE73).withOpacity(0.7)),
                          ),
                          child: const Text(
                            '✦  Established in Siem Reap  ✦',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFFE4A0),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Crafted in\nCambodia',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ancient techniques preserved through generations. Every piece tells a story.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xCCFFFFFF),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: FilledButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.collections),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFD8AE73),
                            foregroundColor: const Color(0xFF4A321B),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Explore the Collection',
                            style: TextStyle(fontWeight: FontWeight.w700),
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
    );
  }
}
