import 'package:flutter/material.dart';
import '../../../../../core/helpers/extentions.dart';
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
    color: Colors.green,
    onTap: () => context.pushNamed(Routes.usersView),
  ),

  DashboardItemEntity(
    title: 'Products',
    icon: Icons.shopping_bag_rounded,
    color: Colors.blue,
    onTap: () => context.pushNamed(Routes.productsView),
  ),

  DashboardItemEntity(
    title: 'Orders',
    icon: Icons.shopping_cart_checkout_rounded,
    color: Colors.orange,
    onTap: () => context.pushNamed(Routes.ordersView),
  ),

  DashboardItemEntity(
    title: 'Analytics',
    icon: Icons.bar_chart_rounded,
    color: Colors.purple,
    onTap: () {},
  ),

  DashboardItemEntity(
    title: 'Settings',
    icon: Icons.settings_rounded,
    color: Colors.pink,
    onTap: () => context.pushNamed(Routes.settingsView),
  ),
];
