import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/dashboard_item_entity.dart';
import 'dashboard_banner_card.dart';
import 'dashboard_grid_view.dart';
import 'dashboard_quick_actions_header.dart';

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardItems = getDashboardItems(context);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      physics: const BouncingScrollPhysics(),
      children: [
        const DashboardBannerCard(),
        Gap(20.h),
        DashboardQuickActionsHeader(itemCount: dashboardItems.length),
        Gap(12.h),
        DashboardGridView(dashboardItems: dashboardItems),
        Gap(24.h),
      ],
    );
  }
}
