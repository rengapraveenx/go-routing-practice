import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

/// Shell wrapper for the main app with persistent bottom navigation.
///
/// [StatefulShellRoute] keeps each tab's navigator stack alive.
/// This widget receives [navigationShell] from the router.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  /// Provided by StatefulShellRoute — manages branch navigation.
  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    _TabItem(
      label: 'Products',
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
      route: AppRoutes.products,
    ),
    _TabItem(
      label: 'Cart',
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      route: AppRoutes.cart,
    ),
    _TabItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // Renders the current tab's page
      bottomNavigationBar: _AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // goBranch switches tabs while preserving each tab's stack
          navigationShell.goBranch(
            index,
            // initialLocation: go to branch root if already on it
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceVariant, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: HomeShellPage._tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                activeIcon: Icon(tab.activeIcon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
}
