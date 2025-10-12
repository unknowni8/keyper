import 'package:app_ui/app_ui.dart' show AppColors, AppLogo, AppSpacing;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyper/l10n/l10n.dart';
import 'package:keyper/theme_selector/view/theme_selector.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  static const double _contentPadding = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(AppSpacing.lg),
        bottomRight: Radius.circular(AppSpacing.lg),
      ),
      child: Drawer(
        backgroundColor: AppColors.darkBackground,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: kToolbarHeight,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xlg,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: _contentPadding + AppSpacing.xxs,
                horizontal: _contentPadding,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppLogo.light(),
              ),
            ),
            // Theme selector
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: _contentPadding,
              ),
              child: const ThemeSelector(),
            ),
            const _NavDrawerDivider(),
            ListTile(
              leading: const Icon(Icons.call_outlined),
              title: Text(context.l10n.callLogOption),
              onTap: () {
                context
                  ..pop()
                  ..goNamed('call_log');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavDrawerDivider extends StatelessWidget {
  const _NavDrawerDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.outlineOnDark);
  }
}
