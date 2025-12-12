import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors - Softer, warmer palette
  static const Color lightPrimary = Color(0xFF7C3AED); // Violet
  static const Color lightSecondary = Color(0xFF06B6D4); // Cyan
  static const Color lightAccent = Color(0xFFF43F5E); // Rose
  static const Color lightBackground = Color(0xFFFAFBFC); // Warmer off-white
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(
    0xFFF1F5F9,
  ); // Soft gray surface
  static const Color lightText = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0); // Soft border color
  static const Color lightError = Color(0xFFDC2626); // Red

  // Dark Theme Colors - Rich deep palette
  static const Color darkPrimary = Color(0xFFA78BFA); // Light violet
  static const Color darkSecondary = Color(0xFF22D3EE); // Bright cyan
  static const Color darkAccent = Color(0xFFFB7185); // Rose
  static const Color darkBackground = Color(0xFF0F0F23);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkError = Color(0xFFF87171);

  // Category Colors - Vibrant Palette
  static const Map<String, Color> categoryColors = {
    'هەموو': Color(0xFF64748B), // Slate
    'کار': Color(0xFF6366F1), // Indigo
    'کەسی': Color(0xFF14B8A6), // Teal
    'کڕین': Color(0xFFF97316), // Orange
    'تەندروستی': Color(0xFFEC4899), // Pink
    'هیتر': Color(0xFF8B5CF6), // Violet
  };

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightSecondary,
      surface: lightSurface,
      surfaceContainerHighest: lightSurfaceVariant,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightText,
      outline: lightBorder,
      error: lightError,
      onError: Colors.white,
    ),
    dividerColor: lightBorder,
    textTheme: GoogleFonts.notoSansArabicTextTheme().copyWith(
      displayLarge: GoogleFonts.notoSansArabic(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),
      displayMedium: GoogleFonts.notoSansArabic(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightText,
      ),
      bodyLarge: GoogleFonts.notoSansArabic(fontSize: 16, color: lightText),
      bodyMedium: GoogleFonts.notoSansArabic(
        fontSize: 14,
        color: lightTextSecondary,
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: lightBackground,
      foregroundColor: lightText,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.notoSansArabic(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightText,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: lightSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: lightBorder.withValues(alpha: 0.5)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.notoSansArabic(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimary,
        side: BorderSide(color: lightPrimary.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.notoSansArabic(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: lightPrimary.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: lightSurfaceVariant,
      selectedColor: lightPrimary,
      labelStyle: GoogleFonts.notoSansArabic(fontSize: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide.none,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return lightPrimary;
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return lightPrimary.withValues(alpha: 0.3);
        return Colors.grey.shade200;
      }),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      surface: darkSurface,
      surfaceContainerHighest: Color(0xFF252542),
      onPrimary: darkBackground,
      onSecondary: darkBackground,
      onSurface: darkText,
      outline: Color(0xFF2A2A4A),
      error: darkError,
      onError: darkBackground,
    ),
    dividerColor: const Color(0xFF2A2A4A),
    textTheme: GoogleFonts.notoSansArabicTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          displayLarge: GoogleFonts.notoSansArabic(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
          displayMedium: GoogleFonts.notoSansArabic(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
          bodyLarge: GoogleFonts.notoSansArabic(fontSize: 16, color: darkText),
          bodyMedium: GoogleFonts.notoSansArabic(
            fontSize: 14,
            color: darkTextSecondary,
          ),
        ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: darkBackground,
      foregroundColor: darkText,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.notoSansArabic(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.notoSansArabic(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimary,
        side: BorderSide(color: darkPrimary.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.notoSansArabic(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: darkPrimary.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF252542),
      selectedColor: darkPrimary,
      labelStyle: GoogleFonts.notoSansArabic(fontSize: 15, color: darkText),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide.none,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return darkPrimary;
        return Colors.grey.shade600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return darkPrimary.withValues(alpha: 0.3);
        return Colors.grey.shade800;
      }),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static Color getCategoryColor(String category) {
    return categoryColors[category] ??
        categoryColors['هیتر'] ??
        const Color(0xFF8B5CF6);
  }
}
