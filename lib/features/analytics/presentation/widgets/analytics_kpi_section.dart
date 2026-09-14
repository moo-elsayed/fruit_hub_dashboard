import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_kpi_entity.dart';

import 'analytics_kpi_card.dart';

class AnalyticsKpiSection extends StatelessWidget {
  const AnalyticsKpiSection({super.key, required this.kpi});

  final AnalyticsKpiEntity kpi;

  @override
  Widget build(BuildContext context) {
    final avgOrderValue = kpi.totalOrders > 0
        ? (kpi.totalRevenue / kpi.totalOrders).toStringAsFixed(1)
        : '0.0';

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AnalyticsKpiCard(
          title: AppStrings.totalRevenue,
          value: '${kpi.totalRevenue.toStringAsFixed(0)} ${AppStrings.pounds}',
          icon: Icons.monetization_on_rounded,
          accentColor: AppPalette.accentGreen,
        ),
        AnalyticsKpiCard(
          title: AppStrings.totalOrders,
          value: '${kpi.totalOrders}',
          icon: Icons.shopping_cart_rounded,
          accentColor: AppPalette.dashboardOrders,
        ),
        AnalyticsKpiCard(
          title: AppStrings.averageOrderValue,
          value: '$avgOrderValue ${AppStrings.pounds}',
          icon: Icons.trending_up_rounded,
          accentColor: AppPalette.dashboardProducts,
        ),
        AnalyticsKpiCard(
          title: AppStrings.totalUsers,
          titleSpan: TextSpan(
            children: [
              TextSpan(
                text: '${AppStrings.totalUsers} ',
                style: AppTextStyles.font11Regular.copyWith(
                  color: context.colors.subText,
                ),
              ),
              TextSpan(
                text: '(${kpi.verifiedUsers} ${AppStrings.verifiedUsers})',
                style: AppTextStyles.font11Medium.copyWith(
                  color: AppPalette.accentGreen,
                ),
              ),
            ],
          ),
          value: '${kpi.totalUsers}',
          icon: Icons.people_alt_rounded,
          accentColor: AppPalette.dashboardUsers,
        ),
      ],
    );
  }
}
