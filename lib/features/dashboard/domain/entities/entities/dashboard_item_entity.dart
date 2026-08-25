import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import '../../../../../core/routing/routes.dart';

class DashboardItemEntity {
  DashboardItemEntity({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final void Function() onTap;
}

List<DashboardItemEntity> getDashboardItems(BuildContext context) => [
  DashboardItemEntity(
    title: 'Users',
    icon: Icons.people_alt_rounded,
    color: AppPalette.dashboardUsers,
    onTap: () => context.pushNamed(Routes.usersView),
  ),

  DashboardItemEntity(
    title: 'Products',
    icon: Icons.shopping_bag_rounded,
    color: AppPalette.dashboardProducts,
    onTap: () => context.pushNamed(Routes.productsView),
  ),

  DashboardItemEntity(
    title: 'Orders',
    icon: Icons.shopping_cart_checkout_rounded,
    color: AppPalette.dashboardOrders,
    onTap: () => context.pushNamed(Routes.ordersView),
  ),

  DashboardItemEntity(
    title: 'Analytics',
    icon: Icons.bar_chart_rounded,
    color: AppPalette.dashboardAnalytics,
    onTap: () {},
  ),

  DashboardItemEntity(
    title: 'Settings',
    icon: Icons.settings_rounded,
    color: AppPalette.dashboardSettings,
    onTap: () => context.pushNamed(Routes.settingsView),
  ),
];
