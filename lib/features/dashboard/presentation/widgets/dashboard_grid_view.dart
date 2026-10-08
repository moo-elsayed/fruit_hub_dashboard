import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/items/dashboard_item.dart';

import 'dashboard_item_widget.dart';

class DashboardGridView extends StatelessWidget {
  const DashboardGridView({super.key, required this.dashboardItems});

  final List<DashboardItem> dashboardItems;

  @override
  Widget build(BuildContext context) => GridView.builder(
    itemCount: dashboardItems.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      childAspectRatio: 1.25,
    ),
    itemBuilder: (context, index) =>
        DashboardItemWidget(entity: dashboardItems[index])
            .animate(delay: Duration(milliseconds: 60 * index))
            .slideY(begin: 0.15, duration: 350.ms)
            .fadeIn(duration: 350.ms),
  );
}
