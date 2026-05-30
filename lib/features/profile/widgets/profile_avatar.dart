import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.initials,
    this.networkImageUrl,
    this.localFile,
    this.radius = 48,
    this.showEditButton = false,
    this.onEditTap,
  });

  final String initials;
  final String? networkImageUrl;
  final File? localFile;
  final double radius;
  final bool showEditButton;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final avatarContent = localFile != null
        ? Image.file(localFile!, fit: BoxFit.cover)
        : networkImageUrl != null
        ? Image.network(
            networkImageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _InitialsAvatar(initials: initials, radius: radius),
          )
        : _InitialsAvatar(initials: initials, radius: radius);

    final avatar = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD8AE73),
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarContent,
    );

    if (!showEditButton) {
      return avatar;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 2,
          bottom: 2,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFF1C766),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 16,
                color: Color(0xFF7B5200),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials, required this.radius});

  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: GoogleFonts.cormorantGaramond(
          fontSize: radius * 0.5,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4A321B),
        ),
      ),
    );
  }
}
