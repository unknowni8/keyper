import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyper/navigation/view/bottom_nav_bar.dart';
import 'package:keyper/navigation/view/nav_drawer.dart';

class AppShell extends StatelessWidget {
  /// Constructs an [AppShell].
  const AppShell({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('AppShell'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  // #docregion configuration-custom-shell
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(),
      // The StatefulNavigationShell from the associated StatefulShellRoute is
      // directly passed as the body of the Scaffold.
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        // Here, the items of BottomNavigationBar are hard coded. In a real
        // world scenario, the items would most likely be generated from the
        // branches of the shell route, which can be fetched using
        // `navigationShell.route.branches`.
        navigationShell: navigationShell,
      ),
    );
  }
  // #enddocregion configuration-custom-shell
}
