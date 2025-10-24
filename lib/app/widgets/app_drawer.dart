import 'package:app_ui/app_ui.dart' show AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyper/app/bloc/navigation_cubit.dart';
import 'package:keyper/app/widgets/app_drawer_footer.dart';
import 'package:keyper/app/widgets/app_drawer_header.dart';
import 'package:keyper/l10n/l10n.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(AppSpacing.xlg),
        bottomRight: Radius.circular(AppSpacing.xlg),
      ),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, index) {
          return NavigationDrawer(
            tilePadding: const EdgeInsetsGeometry.all(AppSpacing.md),
            header: const AppDrawerHeader(),
            selectedIndex: index,
            onDestinationSelected: (value) {
              context.read<NavigationCubit>().update(value);
            },
            footer: const AppDrawerFooter(),
            children: [
              // Navigation section
              NavigationDrawerDestination(
                icon: const Icon(Icons.security_outlined),
                selectedIcon: const Icon(Icons.security),
                label: Text(context.l10n.vault),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.call_outlined),
                selectedIcon: const Icon(Icons.call),
                label: Text(context.l10n.callLogsTitle),
              ),
              // Preferences section
              NavigationDrawerDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: Text(context.l10n.settings),
              ),
              // Support section
              NavigationDrawerDestination(
                icon: const Icon(Icons.info_outlined),
                selectedIcon: const Icon(Icons.info),
                label: Text(context.l10n.about),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.help_outline),
                selectedIcon: const Icon(Icons.help),
                label: Text(context.l10n.helpAndSupport),
              ),
            ],
          );
        },
      ),
    );
  }
}
