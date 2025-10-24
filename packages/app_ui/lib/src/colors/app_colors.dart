import 'package:flutter/material.dart';

/// Defines the color palette for the App UI Kit.
abstract class AppColors {

  static const Color lightModeSurface = Color(0xFFf8f9fa);
  static const Color darkModeSurface = Color(0xFF212529);

  static const Color lightModeOnSurface = Color(0xFF212529);
  static const Color darkModeOnSurface = Color(0xFFf8f9fa);

  static const Color lightModeError = Color(0xFF800000);
  static const Color darkModeError = Color(0xFFFFC7C7);

  /// The primary color of the app.
  static const Color lightModePrimary = Color(0xFF253900);
  static const Color darkModePrimary = Color(0xFF08CB00);
  
  /// The secondary color of the app.
  static const Color lightModeSecondary = Color(0xFF253900);
  static const Color darkModeSecondary = Color(0xFFe9ecef);

  /// Black
  static const Color black = Color(0xFF000000);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// The red primary color and swatch.
  static const MaterialColor red = Colors.red;

  /// Grey
  static const Color grey = Color(0xFF999999);

}
