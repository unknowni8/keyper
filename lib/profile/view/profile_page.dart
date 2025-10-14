import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyper/l10n/l10n.dart';
import 'package:keyper/profile/view/language_selector.dart';
import 'package:keyper/theme_selector/bloc/theme_mode_bloc.dart';
import 'package:keyper/theme_selector/view/theme_selector.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          ListTile(
            title: Text(
              context.l10n.themeSectionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: Chip(
              label: Text(
                context.read<ThemeModeBloc>().state == ThemeMode.system
                    ? context.l10n.systemOption
                    : context.read<ThemeModeBloc>().state == ThemeMode.dark
                    ? context.l10n.darkModeOption
                    : context.l10n.lightModeOption,
              ),
            ),
            onTap: () {
              unawaited(
                showAppModal<void>(
                  context: context,
                  builder: (context) => const ThemeSelector(),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          ListTile(
            title: Text(
              context.l10n.languageSectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () {
              unawaited(
                showAppModal<void>(
                  context: context,
                  builder: (context) => const LanguageSelector(),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}
