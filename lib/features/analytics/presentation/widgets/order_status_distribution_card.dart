import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/order_status_stat_entity.dart';

import 'analytics_empty_state_card.dart';

class OrderStatusDistributionCard extends StatelessWidget {
  const OrderStatusDistributionCard({super.key, required this.statusStats});

  final List<OrderStatusStatEntity> statusStats;

  @override
  Widget build(BuildContext context) {
    final totalCount = statusStats.fold<int>(0, (sum, s) => sum + s.count);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.orderStatusDistribution,
                style: AppTextStyles.font15Bold.copyWith(
                  color: context.colors.mainText,
                ),
              ),
              Text(
                '$totalCount ${AppStrings.orders}',
                style: AppTextStyles.font12Medium.copyWith(
                  color: context.colors.subText,
                ),
              ),
            ],
          ),
          if (totalCount == 0)
            const AnalyticsEmptyStateCard()
          else ...[
            SizedBox(
              height: 160.h,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 42.r,
                  sections: _buildSections(totalCount),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              children: statusStats.map((stat) {
                final pct = totalCount > 0
                    ? ((stat.count / totalCount) * 100).toStringAsFixed(0)
                    : '0';
                return _StatusChip(
                  label: stat.status.getName,
                  count: stat.count,
                  percentage: pct,
                  color: stat.status.color,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int totalCount) => statusStats.map((
    stat,
  ) {
    final pct = totalCount > 0 ? (stat.count / totalCount) * 100 : 0.0;
    return PieChartSectionData(
      color: stat.status.color,
      value: stat.count.toDouble(),
      title: stat.count > 0 ? '${pct.toStringAsFixed(0)}%' : '',
      radius: 36.r,
      titleStyle: AppTextStyles.font10Bold.copyWith(color: AppPalette.white),
    );
  }).toList();
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });

  final String label;
  final int count;
  final String percentage;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 6.w,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8.r,
        height: 8.r,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      Text(
        '$label ($count)',
        style: AppTextStyles.font11Medium.copyWith(
          color: context.colors.mainText,
        ),
      ),
    ],
  );
}
