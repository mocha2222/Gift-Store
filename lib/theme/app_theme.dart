import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData theme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8C6500),
      brightness: Brightness.light,
      surface: const Color(0xFFFBF5EA),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF7F0E4),
      textTheme: GoogleFonts.cormorantGaramondTextTheme().copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 58,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2C261E),
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2C261E),
        ),
        titleLarge: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2C261E),
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5F564C),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: const Color(0xFF61584E),
        ),
      ),
    );
  }
}