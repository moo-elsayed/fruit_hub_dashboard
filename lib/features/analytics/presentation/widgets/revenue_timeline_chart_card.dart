import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/revenue_data_point_entity.dart';

import 'revenue_line_chart.dart';

class RevenueTimelineChartCard extends StatelessWidget {
  const RevenueTimelineChartCard({super.key, required this.dataPoints});

  final List<RevenueDataPointEntity> dataPoints;

  @override
  Widget build(BuildContext context) {
    final totalRangeRevenue = dataPoints.fold<double>(
      0.0,
      (sum, p) => sum + p.revenue,
    );

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2.h,
                children: [
                  Text(
                    AppStrings.revenueTimeline,
                    style: AppTextStyles.font15Bold.copyWith(
                      color: context.colors.mainText,
                    ),
                  ),
                  Text(
                    '${totalRangeRevenue.toStringAsFixed(0)} ${AppStrings.pounds}',
                    style: AppTextStyles.font18Bold.copyWith(
                      color: AppPalette.primaryGreen,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppPalette.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.w,
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      size: 14.r,
                      color: AppPalette.accentGreen,
                    ),
                    Text(
                      '${dataPoints.length} ${AppStrings.days}',
                      style: AppTextStyles.font11Medium.copyWith(
                        color: AppPalette.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 200.h,
            child: dataPoints.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.noRevenueData,
                      style: AppTextStyles.font13Medium.copyWith(
                        color: context.colors.subText,
                      ),
                    ),
                  )
                : RevenueLineChart(dataPoints: dataPoints),
          ),
        ],
      ),
    );
  }
}
