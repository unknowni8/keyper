import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyper/profile/bloc/locale_cubit.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.watch<LocaleCubit>().state;
    final chipColor = theme.colorScheme.primary;

    Widget buildChip({
      required Locale value,
      required String label,
      required Key key,
    }) {
      final isSelected = locale.languageCode == value.languageCode;
      return ChoiceChip(
        key: key,
        selected: isSelected,
        onSelected: (_) =>
            context.read<LocaleCubit>().setLocale(value),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : chipColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        backgroundColor: chipColor.withValues(alpha: 0.1),
        selectedColor: chipColor,
        elevation: isSelected ? 2 : 0,
        shadowColor: chipColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? chipColor
                : chipColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      );
    }

    return Container(
      key: const Key('languageSelector_container'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineOnDark.withValues(alpha: 0.2),
        ),
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          buildChip(
            value: const Locale('en'),
            label: 'English',
            key: const Key('languageSelector_en'),
          ),
          buildChip(
            value: const Locale('hi'),
            label: 'हिंदी',
            key: const Key('languageSelector_hi'),
          ),
        ],
      ),
    );
  }
}