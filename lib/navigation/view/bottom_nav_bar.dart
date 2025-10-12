import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyper/l10n/l10n.dart';

@visibleForTesting
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          label: context.l10n.bottomNavBarDashboard,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.person,
          ),
          label: context.l10n.bottomNavBarProfile,
        ),
      ],
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => _onTap(context, index),
    );
  }

    /// NOTE: For a slightly more sophisticated branch switching, change the onTap
  /// handler on the BottomNavigationBar above to the following:
  /// `onTap: (int index) => _onTap(context, index),`
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
