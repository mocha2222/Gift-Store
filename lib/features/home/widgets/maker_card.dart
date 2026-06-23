import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../data/home_mock_data.dart';

class MakerCard extends StatelessWidget {
  const MakerCard({super.key, required this.item, required this.onTap});

  final MakerItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Helper to build avatar image
    Widget buildAvatarImage() {
      final avatarUrl = item.avatarUrl;
      final fallbackWidget = Container(
        color: const Color(0xFFD8AE73),
        child: const Icon(
          Icons.person_rounded,
          size: 36,
          color: Colors.white,
        ),
      );

      if (avatarUrl.isEmpty) {
        return fallbackWidget;
      }

      if (avatarUrl.startsWith('data:') || avatarUrl.length > 200) {
        try {
          String base64Str = avatarUrl;
          if (base64Str.startsWith('data:')) {
            final commaIndex = base64Str.indexOf(',');
            if (commaIndex != -1) {
              base64Str = base64Str.substring(commaIndex + 1);
            }
          }
          final bytes = base64Decode(base64Str.trim());
          return Image.memory(bytes, fit: BoxFit.cover);
        } catch (_) {
          return fallbackWidget;
        }
      }

      if (avatarUrl.startsWith('http')) {
        return Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackWidget,
        );
      }

      return Image.asset(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallbackWidget,
      );
    }

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
                child: buildAvatarImage(),
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