import 'package:app_logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyper/l10n/l10n.dart';
import 'package:keyper/theme_selector/bloc/theme_mode_bloc.dart';

/// A modern segmented control to select a new [ThemeMode]
///
/// Requires a [ThemeModeBloc] to be provided in the widget tree
/// (usually above [MaterialApp])
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeMode = context.watch<ThemeModeBloc>().state;
    AppLogger.info('ThemeSelector.build: themeMode = $themeMode');
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          key: const Key('themeSelector_system'),
          leading: const Icon(Icons.brightness_auto, size: 20),
          title: Text(l10n.systemOption),
          trailing: themeMode == ThemeMode.system
              ? const Icon(Icons.check, color: Colors.blue)
              : null,
          onTap: () => context.read<ThemeModeBloc>().add(
                const ThemeModeChanged(ThemeMode.system),
              ),
        ),
        ListTile(
          key: const Key('themeSelector_light'),
          leading: const Icon(Icons.wb_sunny_outlined, size: 20),
          title: Text(l10n.lightModeOption),
          trailing: themeMode == ThemeMode.light
              ? const Icon(Icons.check, color: Colors.blue)
              : null,
          onTap: () => context.read<ThemeModeBloc>().add(
                const ThemeModeChanged(ThemeMode.light),
              ),
        ),
        ListTile(
          key: const Key('themeSelector_dark'),
          leading: const Icon(Icons.nightlight_round, size: 20),
          title: Text(l10n.darkModeOption),
          trailing: themeMode == ThemeMode.dark
              ? const Icon(Icons.check, color: Colors.blue)
              : null,
          onTap: () => context.read<ThemeModeBloc>().add(
                const ThemeModeChanged(ThemeMode.dark),
              ),
        ),
      ],
    );
  }
}
