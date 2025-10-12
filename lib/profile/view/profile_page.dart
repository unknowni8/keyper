import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:keyper/l10n/l10n.dart';
import 'package:keyper/profile/view/language_selector.dart';
import 'package:keyper/theme_selector/view/theme_selector.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.profileSettingsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.themeSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                const ThemeSelector(key: Key('profile_theme_selector')),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.languageSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                const LanguageSelector(),
              ],
            ),
            const SizedBox(height: AppSpacing.xlg),
          ],
        ),
      ),
    );
  }
}
