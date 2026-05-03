import 'package:flutter/material.dart';

class AsumiTheme {
  // ---- Design Tokens ----
  static const Color rose = Color(0xFFC08497);
  static const Color roseLight = Color(0xFFE8B4C8);
  static const Color lavender = Color(0xFFB8A9C9);
  static const Color gold = Color(0xFFC9A96E);
  static const Color cream = Color(0xFFFAF6F3);
  static const Color ivory = Color(0xFFF5F0EB);
  static const Color plum = Color(0xFF2D1B2E);
  static const Color charcoal = Color(0xFF1A1A2E);

  // Vuetify palette mapping
  static const Color violet500 = Color(0xFF8B5CF6);
  static const Color violet600 = Color(0xFF7C3AED);
  static const Color violet400 = Color(0xFFA78BFA);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color rose500 = Color(0xFFF43F5E);
  static const Color emerald400 = Color(0xFF34D399);

  // Fonts
  static const String displayFont = 'Playfair Display';
  static const String bodyFont = 'DM Sans';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: rose,
      colorScheme: const ColorScheme.light(
        primary: rose,
        secondary: pink500,
        tertiary: amber400,
        error: rose500,
        surface: Color(0xFFFFFFFF),
      ),
      scaffoldBackgroundColor: cream,
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.72),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: plum,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: roseLight.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: rose, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: rose500),
        ),
        hintStyle: TextStyle(color: lavender.withValues(alpha: 0.6)),
        labelStyle: const TextStyle(color: plum),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: rose,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: rose.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      dividerTheme: DividerThemeData(
        color: roseLight.withValues(alpha: 0.3),
        thickness: 0.5,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: displayFont, color: plum),
        displayMedium: TextStyle(fontFamily: displayFont, color: plum),
        headlineMedium: TextStyle(fontFamily: displayFont, color: plum),
        titleLarge: TextStyle(fontFamily: displayFont, color: plum),
        titleMedium: TextStyle(fontFamily: bodyFont, color: plum),
        bodyLarge: TextStyle(fontFamily: bodyFont, color: plum),
        bodyMedium: TextStyle(fontFamily: bodyFont, color: plum),
        bodySmall: TextStyle(fontFamily: bodyFont, color: lavender),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      primaryColor: rose,
      colorScheme: const ColorScheme.dark(
        primary: roseLight,
        secondary: pink500,
        tertiary: amber400,
        error: rose500,
        surface: Color(0xFF1E0A3C),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0724),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E0A3C).withValues(alpha: 0.75),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF3E8FF),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: lavender.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: roseLight, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: rose500),
        ),
        hintStyle: TextStyle(color: lavender.withValues(alpha: 0.5)),
        labelStyle: const TextStyle(color: Color(0xFFF3E8FF)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: rose,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: rose.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      dividerTheme: DividerThemeData(
        color: lavender.withValues(alpha: 0.2),
        thickness: 0.5,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: displayFont, color: Color(0xFFF3E8FF)),
        displayMedium: TextStyle(fontFamily: displayFont, color: Color(0xFFF3E8FF)),
        headlineMedium: TextStyle(fontFamily: displayFont, color: Color(0xFFF3E8FF)),
        titleLarge: TextStyle(fontFamily: displayFont, color: Color(0xFFF3E8FF)),
        titleMedium: TextStyle(fontFamily: bodyFont, color: Color(0xFFF3E8FF)),
        bodyLarge: TextStyle(fontFamily: bodyFont, color: Color(0xFFF3E8FF)),
        bodyMedium: TextStyle(fontFamily: bodyFont, color: Color(0xFFF3E8FF)),
        bodySmall: TextStyle(fontFamily: bodyFont, color: lavender),
      ),
    );
  }
}
