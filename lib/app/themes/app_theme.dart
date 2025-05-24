import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app/themes/dark_theme.dart';
import 'package:flutter_boilerplate/app/themes/light_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();
  
  // Color palette
  static const Color primaryColor = Color(0xFF3174F2);
  static const Color secondaryColor = Color(0xFF16B3AA);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);

  // Neutral colors
  static const Color neutralBlack = Color(0xFF121212);
  static const Color neutralDarkGrey = Color(0xFF424242);
  static const Color neutralGrey = Color(0xFF9E9E9E);
  static const Color neutralLightGrey = Color(0xFFE0E0E0);
  static const Color neutralWhite = Color(0xFFFAFAFA);
  
  // Theme data
  static ThemeData get lightTheme => LightTheme.theme;
  static ThemeData get darkTheme => DarkTheme.theme;
  
  // Text styles
  static TextTheme get _textTheme => GoogleFonts.interTextTheme();
  
  static TextStyle get headingLarge => _textTheme.headlineLarge!.copyWith(
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static TextStyle get headingMedium => _textTheme.headlineMedium!.copyWith(
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static TextStyle get headingSmall => _textTheme.headlineSmall!.copyWith(
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static TextStyle get titleLarge => _textTheme.titleLarge!.copyWith(
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );
  
  static TextStyle get titleMedium => _textTheme.titleMedium!.copyWith(
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );
  
  static TextStyle get titleSmall => _textTheme.titleSmall!.copyWith(
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );
  
  static TextStyle get bodyLarge => _textTheme.bodyLarge!.copyWith(
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => _textTheme.bodyMedium!.copyWith(
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static TextStyle get bodySmall => _textTheme.bodySmall!.copyWith(
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
}