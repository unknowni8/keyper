import 'package:app_ui/app_ui.dart';
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
    final theme = Theme.of(context);
    final themeMode = context.watch<ThemeModeBloc>().state;
    final chipColor = theme.colorScheme.primary;

    Widget buildChip({
      required ThemeMode value,
      required IconData icon,
      required String label,
      required Key key,
    }) {
      final isSelected = themeMode == value;
      return ChoiceChip(
        key: key,
        selected: isSelected,
        onSelected: (_) {
          context.read<ThemeModeBloc>().add(ThemeModeChanged(value));
        },
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : chipColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : chipColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        backgroundColor: chipColor.withValues(alpha: 0.1),
        selectedColor: chipColor,
        checkmarkColor: Colors.white,
        elevation: isSelected ? 2 : 0,
        shadowColor: chipColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    }

    return Container(
      key: const Key('themeSelector_dropdown'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineOnDark.withValues(alpha: 0.2)),
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          buildChip(
            value: ThemeMode.system,
            icon: Icons.brightness_auto,
            label: l10n.systemOption,
            key: const Key('themeSelector_system_dropdownMenuItem'),
          ),
          buildChip(
            value: ThemeMode.light,
            icon: Icons.wb_sunny_outlined,
            label: l10n.lightModeOption,
            key: const Key('themeSelector_light_dropdownMenuItem'),
          ),
          buildChip(
            value: ThemeMode.dark,
            icon: Icons.nightlight_round,
            label: l10n.darkModeOption,
            key: const Key('themeSelector_dark_dropdownMenuItem'),
          ),
        ],
      ),
    );
  }
}
