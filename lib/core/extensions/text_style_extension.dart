import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  // Base Styles
  static TextStyle get _baseStyle => const TextStyle(
        fontFamily: 'Gilroy',
        color: Colors.black,
      );

  // Heading Styles
  static TextStyle get h1 => _baseStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h2 => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h3 => _baseStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  // Body Styles
  static TextStyle get bodyLarge => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyMedium => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyRegular => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodySmall => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  // Button Styles
  static TextStyle get buttonPrimary => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get buttonSecondary => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFFF8800),
      );

  // Utility methods
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);
} 