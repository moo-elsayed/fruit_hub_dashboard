import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/dashboard_item_entity.dart';
import 'dashboard_item.dart';

class DashboardGridView extends StatelessWidget {
  const DashboardGridView({super.key, required this.dashboardItems});

  final List<DashboardItemEntity> dashboardItems;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: dashboardItems.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 14.h,
      crossAxisSpacing: 14.w,
      childAspectRatio: 1.2,
    ),
    itemBuilder: (context, index) =>
        DashboardItem(entity: dashboardItems[index])
            .animate(delay: Duration(milliseconds: 60 * index))
            .slideY(begin: 0.15, duration: 350.ms)
            .fadeIn(duration: 350.ms),
  );
}
