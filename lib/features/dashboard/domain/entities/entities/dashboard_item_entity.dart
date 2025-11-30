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
    title: "Add Product",
    icon: Icons.add_box_rounded,
    color: Colors.green,
    onTap: () => context.pushNamed(Routes.productView),
  ),

  DashboardItemEntity(
    title: "All Products",
    icon: Icons.inventory_2_rounded,
    color: Colors.blue,
    onTap: () => context.pushNamed(Routes.productsView),
  ),

  DashboardItemEntity(
    title: "Orders",
    icon: Icons.shopping_cart_checkout_rounded,
    color: Colors.orange,
    onTap: () {},
  ),
  DashboardItemEntity(
    title: "Analytics",
    icon: Icons.bar_chart_rounded,
    color: Colors.purple,
    onTap: () {},
  ),
];
