import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary - Blush Pink (mapped to hex #4b00b2)
  static const Color primary = Color(0xFF4B00B2);
  static const Color primaryContainer = Color(0xFF4B00B2);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary - Light Lavender
  static const Color secondary = Color(0xFFE6E6FA);
  static const Color secondaryContainer = Color(0xFFECECFF);
  static const Color onSecondary = Color(0xFF4B00B2);

  // Surface
  static const Color surface = Color(0xFFF9F9FE);
  static const Color surfaceContainer = Color(0xFFECECFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E2FF);
  static const Color surfaceDim = Color(0xFFD7D7FA);

  // On Colors
  static const Color onSurface = Color(0xFF150B30);
  static const Color onSurfaceVariant = Color(0xFF554A70);

  // Outline
  static const Color outline = Color(0xFF757682);
  static const Color outlineVariant = Color(0xFFC5C6D2);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // Custom Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.05),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> modalShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: Color(0xFFE6E6FA),
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.primary,
        tertiary: Color(0xFF101518),
        onTertiary: AppColors.onPrimary,
        tertiaryContainer: Color(0xFF25292D),
        onTertiaryContainer: Color(0xFF8C9095),
        error: AppColors.error,
        onError: AppColors.onPrimary,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: Color(0xFF93000A),
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        surfaceContainerLowest: Color(0xFFFFFFFF),
        surfaceContainerLow: Color(0xFFEFF4FF),
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: Color(0xFFD3E4FE),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          color: AppColors.onSurface,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          color: AppColors.onSurface,
        ),
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF6F5FD),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        elevation: 6,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.08), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
    );
  }
}
