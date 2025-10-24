import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// The Default App [ThemeData].
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme();

  /// Default `ThemeData` for App UI.
  ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: _scaffoldBackgroundColor,
    );
  }

  /// The light mode scaffold background color.
  Color get _scaffoldBackgroundColor => AppColors.lightModeSurface;

  ColorScheme get _colorScheme => ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.lightModePrimary,
    onPrimary: AppColors.white,
    secondary: AppColors.lightModeSecondary,
    onSecondary: AppColors.white,
    error: AppColors.lightModeError,
    onError: AppColors.white,
    surface: AppColors.lightModeSurface,
    onSurface: AppColors.lightModeOnSurface,
  );
}

/// {@template app_dark_theme}
/// Dark Mode App [ThemeData].
/// {@endtemplate}
class AppDarkTheme extends AppTheme {
  /// {@macro app_dark_theme}
  const AppDarkTheme();

  @override
  ThemeData get themeData => ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    colorScheme: _colorScheme,
    scaffoldBackgroundColor: _scaffoldBackgroundColor,
  );

  @override
  Color get _scaffoldBackgroundColor => AppColors.darkModeSurface;

  @override
  ColorScheme get _colorScheme => ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkModePrimary,
    onPrimary: AppColors.black,
    secondary: AppColors.darkModeSecondary,
    onSecondary: AppColors.black,
    error: AppColors.darkModeError,
    onError: AppColors.black,
    surface: AppColors.darkModeSurface,
    onSurface: AppColors.darkModeOnSurface,
  );
}
