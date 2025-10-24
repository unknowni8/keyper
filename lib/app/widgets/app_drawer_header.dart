import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: AppSpacing.xxxlg,
      child: theme.brightness == Brightness.light
          ? AppLogo.dark()
          : AppLogo.light(),
    );
  }
}
