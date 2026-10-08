import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';

class DashboardItem {
  const DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

List<DashboardItem> getDashboardItems(BuildContext context) => [
  DashboardItem(
    title: AppStrings.users,
    subtitle: AppStrings.usersSubtitle,
    icon: Icons.people_alt_rounded,
    color: AppPalette.dashboardUsers,
    onTap: () => context.pushNamed(Routes.usersView),
  ),
  DashboardItem(
    title: AppStrings.products,
    subtitle: AppStrings.productsSubtitle,
    icon: Icons.shopping_bag_rounded,
    color: AppPalette.dashboardProducts,
    onTap: () => context.pushNamed(Routes.productsView),
  ),
  DashboardItem(
    title: AppStrings.orders,
    subtitle: AppStrings.ordersSubtitle,
    icon: Icons.shopping_cart_checkout_rounded,
    color: AppPalette.dashboardOrders,
    onTap: () => context.pushNamed(Routes.ordersView),
  ),
  DashboardItem(
    title: AppStrings.analytics,
    subtitle: AppStrings.analyticsSubtitle,
    icon: Icons.bar_chart_rounded,
    color: AppPalette.dashboardAnalytics,
    onTap: () => context.pushNamed(Routes.analyticsView),
  ),
  DashboardItem(
    title: AppStrings.settings,
    subtitle: AppStrings.settingsSubtitle,
    icon: Icons.settings_rounded,
    color: AppPalette.dashboardSettings,
    onTap: () => context.pushNamed(Routes.settingsView),
  ),
];
