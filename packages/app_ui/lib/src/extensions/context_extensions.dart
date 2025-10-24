import 'package:flutter/material.dart';

extension AppSizingContextExtensions on BuildContext {
  /// Returns the [MediaQueryData] for the current [BuildContext].
  Size get mediaQuerySize => MediaQuery.sizeOf(this);

  /// Returns the [width] of the current [BuildContext].
  double get width => mediaQuerySize.width;

  /// Returns the [height] of the current [BuildContext].
  double get height => mediaQuerySize.height;

}
