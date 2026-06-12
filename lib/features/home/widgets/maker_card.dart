import 'package:flutter/material.dart';
import '../../../data/home_mock_data.dart';

class MakerCard extends StatelessWidget {
  const MakerCard({super.key, required this.item, required this.onTap});

  final MakerItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E8CF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8D5B0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFF3E7D4), width: 3),
              ),
              child: ClipOval(
                child: item.avatarUrl.startsWith('http')
                  ? Image.network(
                      item.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFD8AE73),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Image.asset(
                      item.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFD8AE73),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              item.role,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: const Color(0xFF8C6500)),
            ),
            const SizedBox(height: 12),
            Text(
              '"${item.quote}"',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF5E5244),
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}