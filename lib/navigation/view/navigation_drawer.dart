import 'package:app_ui/app_ui.dart' show AppLogo, AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keyper/l10n/l10n.dart';
import 'package:keyper/navigation/bloc/bloc.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(AppSpacing.xlg),
        bottomRight: Radius.circular(AppSpacing.xlg),
      ),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, index) {
          return NavigationDrawer(
            selectedIndex: index,
            onDestinationSelected: (value) {
              context.read<NavigationCubit>().update(value);
              context.pop();
            },
            children: [
              DrawerHeader(
                child: theme.brightness == Brightness.light
                    ? AppLogo.dark()
                    : AppLogo.light(),
              ),
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
              const _NavDrawerDivider(),
              // Preferences section
              NavigationDrawerDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: Text(context.l10n.settings),
              ),
              const _NavDrawerDivider(),
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

class _NavDrawerDivider extends StatelessWidget {
  const _NavDrawerDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider();
  }
}
