import 'package:flutter/material.dart';

class AppTextStyles {
  static double multiplier = 0.8;
  static String package = 'holaride_core';
  static String fontFamily = 'Quantico';
  static void updateForScreenSize(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    multiplier = (screenHeight / 812 * 0.8).clamp(0.7, 0.95);
  }
  static TextStyle get headline1 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle get headline2 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static TextStyle get headline3 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headline4 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headline5 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 20,
    fontWeight: FontWeight.w500,
  );
  static TextStyle get headline6 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 18,
    fontWeight: FontWeight.w500,
  );
  // ==================== Titles / Subtitles ====================
  static TextStyle get title => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get subtitle1 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get subtitle2 => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get subtitle2Bold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w600,
  );

  // ==================== Body Text ====================
  static TextStyle get bodyLarge => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodyLargeBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle get bodyLargeSemiBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle get body => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static TextStyle get bodyCaption => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    height: 1.5,
  );

  static TextStyle get bodyBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  static TextStyle get bodySemiBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get bodySmallBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );

  static TextStyle get bodySmallSemiBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get bodySmallMedium => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ==================== Captions / Labels ====================
  static TextStyle get caption => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    height: 1.3,
  );

  static TextStyle get captionBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    height: 1.3,
  );

  static TextStyle get captionSemiBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
    height: 1.3,
  );

  static TextStyle get captionMedium => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    height: 1.3,
  );

  static TextStyle get label => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get labelSmall => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelSmallBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.bold,
  );

  // ==================== Overline / Tiny Text ====================
  static TextStyle get overline => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  static TextStyle get overlineBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static TextStyle get tiny => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 10,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get tinyBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 10,
    fontWeight: FontWeight.bold,
  );

  // ==================== Buttons ====================
  static TextStyle get button => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonLarge => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonSmall => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  // ==================== Links ====================
  static TextStyle get link => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  static TextStyle get linkBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );

  static TextStyle get linkSmall => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  // ==================== Display / Hero Text ====================
  static TextStyle get display => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 48,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
  );

  static TextStyle get displayMedium => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 40,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.8,
  );

  static TextStyle get displaySmall => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 36,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  // ==================== Error / Helper Text ====================
  static TextStyle get error => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.w400,
    color: Colors.red,
  );

  static TextStyle get errorBold => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.w600,
    color: Colors.red,
  );

  static TextStyle get helper => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  // ==================== Placeholder / Hint ====================
  static TextStyle get placeholder => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static TextStyle get hint => TextStyle(
    package: package,
    fontFamily: fontFamily,
    fontSize: multiplier * 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
}