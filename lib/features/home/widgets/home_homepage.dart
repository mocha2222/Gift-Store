import 'package:flutter/material.dart';

import '../../../models/home_mock_data.dart';
import '../../../widgets/header.dart';

class HomeHomepage extends StatelessWidget {
  const HomeHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: _HeroCard(onPressed: () {}),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curated Disciplines',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    for (final item in disciplines)
                      Expanded(child: _DisciplineChip(item: item)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: AppSectionHeader(
              title: 'Trending Gifts',
              actionLabel: 'View All',
              onActionTap: () {},
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.separated(
            itemCount: trendingGifts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              return _GiftCard(item: trendingGifts[index]);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Meet the Makers',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _MakerCard(item: makers.first),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 410,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F1E6), Color(0xFFF0E1C7)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.45, -0.3),
                    radius: 1.2,
                    colors: [
                      Colors.white.withAlpha(235),
                      const Color(0xFFF0E1C7).withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ESTABLISHED IN SIEM REAP',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A6655),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Crafted in\nCambodia',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Experience the quiet luxury of ancient techniques preserved through generations. Every piece tells a story of heritage, patience, and meticulous skill.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: onPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD8AE73),
                    foregroundColor: const Color(0xFF4A321B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Explore the Collection'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DisciplineChip extends StatelessWidget {
  const _DisciplineChip({required this.item});

  final DisciplineItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFFF1E7D5),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: const Color(0xFF8C6500), size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          item.label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: const Color(0xFF4F453A)),
        ),
      ],
    );
  }
}

class _GiftCard extends StatelessWidget {
  const _GiftCard({required this.item});

  final GiftItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F0),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 270,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    item.accent,
                    item.accent.withAlpha((0.35 * 255).round()),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      item.icon,
                      size: 92,
                      color: Colors.white.withAlpha((0.72 * 255).round()),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _LikeButton(onTap: () {}),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.price,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: const Color(0xFF6F6355)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Quick Add →',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF8C6500),
                      fontWeight: FontWeight.w700,
                    ),
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

class _LikeButton extends StatelessWidget {
  const _LikeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1F1F1),
      shape: const CircleBorder(),
      child: InkResponse(
        onTap: onTap,
        radius: 18,
        child: const SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            Icons.favorite_border_rounded,
            size: 18,
            color: Color(0xFF554B44),
          ),
        ),
      ),
    );
  }
}

class _MakerCard extends StatelessWidget {
  const _MakerCard({required this.item});

  final MakerItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E8CF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D5B0)),
      ),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6D4E34), Color(0xFFC99B63)],
              ),
              border: Border.all(color: const Color(0xFFF3E7D4), width: 4),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(item.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            item.role,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: const Color(0xFF8C6500)),
          ),
          const SizedBox(height: 18),
          Text(
            '“${item.quote}”',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF5E5244)),
          ),
        ],
      ),
    );
  }
}
