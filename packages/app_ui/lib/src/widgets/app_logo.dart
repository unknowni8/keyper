import 'package:app_ui/src/generated/generated.dart';
import 'package:flutter/material.dart';

/// {@template app_logo}
/// A default app logo.
/// {@endtemplate}
class AppLogo extends StatelessWidget {
  /// {@macro app_logo}
  const AppLogo._({
    required SvgGenImage logo,
    double width = 240,
    double height = 32,
    super.key,
  })  : _logo = logo,
        _width = width,
        _height = height;

  /// The dark app logo.
  AppLogo.dark({Key? key}) : this._(key: key, logo: Assets.images.logoDarkVector);

  /// The light app logo.
  AppLogo.light({Key? key}) : this._(key: key, logo: Assets.images.logoLightVector);

  /// The logo to be displayed.
  final SvgGenImage _logo;

  /// Desired logo dimensions.
  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return _logo.svg(
      fit: BoxFit.contain,
      width: _width,
      height: _height,
    );
  }
}
