import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyper/l10n/l10n.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => _onTap(context, index),
      maintainBottomViewPadding: true,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 40,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.xxxlg),
      ),
      height: AppSpacing.xxxlg96,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          label: context.l10n.bottomNavBarHome,
        ),
        NavigationDestination(
          icon: const Icon(Icons.apps_outlined),
          label: context.l10n.bottomNavBarFeatures,
        ),
        NavigationDestination(
          icon: const Icon(Icons.timeline_outlined),
          label: context.l10n.bottomNavBarTimeline,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          label: context.l10n.bottomNavBarProfile,
        ),
      ],
    );
  }

  /// NOTE: For a slightly more sophisticated branch switching, change the onTap
  /// handler on the BottomNavigationBar above to the following:
  /// `onTap: (int index) => _onTap(context, index),`
  Future<void> _onTap(BuildContext context, int index) async {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // Support navigating to the initial location when tapping the currently
      // active item.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
