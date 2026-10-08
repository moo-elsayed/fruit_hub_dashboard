import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/items/dashboard_item.dart';
import 'package:gap/gap.dart';

import 'dashboard_banner_card.dart';
import 'dashboard_grid_view.dart';
import 'dashboard_quick_actions_header.dart';

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = EasyLocalization.of(context)?.locale;
    final dashboardItems = getDashboardItems(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          const DashboardBannerCard(),
          Gap(20.h),
          DashboardQuickActionsHeader(itemCount: dashboardItems.length),
          Gap(12.h),
          Expanded(child: DashboardGridView(dashboardItems: dashboardItems)),
        ],
      ),
    );
  }
}
