import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/revenue_data_point_entity.dart';

class RevenueLineChart extends StatelessWidget {
  const RevenueLineChart({super.key, required this.dataPoints});

  final List<RevenueDataPointEntity> dataPoints;

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    double maxY = 0.0;

    for (var i = 0; i < dataPoints.length; i++) {
      final rev = dataPoints[i].revenue;
      if (rev > maxY) maxY = rev;
      spots.add(FlSpot(i.toDouble(), rev));
    }

    if (maxY == 0) maxY = 100;

    // Calculate a clean rounded ceiling and interval for the Y-axis (e.g. multiples of 100, 250, 500, etc.)
    final rawInterval = maxY / 4;
    final niceIntervalY = _calculateNiceInterval(rawInterval);
    final niceMaxY = (niceIntervalY * 4).toDouble();

    // For bottom titles: in 7-day view show every day (interval: 1), in longer ranges spread evenly
    final xInterval = dataPoints.length <= 8
        ? 1.0
        : (dataPoints.length / 5).ceilToDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: niceIntervalY,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: context.colors.border.withValues(alpha: 0.6),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: context.colors.border.withValues(alpha: 0.3),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46.w,
              interval: niceIntervalY,
              getTitlesWidget: (value, meta) {
                if (value > niceMaxY || value < 0) {
                  return const SizedBox.shrink();
                }
                final intVal = value.round();
                return Text(
                  intVal >= 1000
                      ? '${(intVal / 1000).toStringAsFixed(intVal % 1000 == 0 ? 0 : 1)}k'
                      : '$intVal',
                  style: AppTextStyles.font10Regular.copyWith(
                    color: context.colors.subText,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26.h,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                final lastIndex = dataPoints.length - 1;

                // Ensure title only prints exactly on integer ticks that match data point indices
                if ((value - index).abs() > 0.01 ||
                    index < 0 ||
                    index > lastIndex) {
                  return const SizedBox.shrink();
                }

                // Prevent collision with the last date label:
                // If this label is close to the final date (distance < xInterval * 0.75), skip it
                // unless it is the final date itself.
                final distToLast = lastIndex - index;
                if (index != lastIndex &&
                    distToLast > 0 &&
                    distToLast < xInterval * 0.75) {
                  return const SizedBox.shrink();
                }

                final date = dataPoints[index].date;
                return Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    DateFormat('d MMM').format(date),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font10Regular.copyWith(
                      color: context.colors.subText,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (dataPoints.length - 1).toDouble().clamp(0.0, double.infinity),
        minY: 0,
        maxY: niceMaxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
              final index = spot.x.toInt();
              final point = dataPoints[index];
              final dateStr = DateFormat('yyyy-MM-dd').format(point.date);
              return LineTooltipItem(
                '$dateStr\n${point.revenue.toStringAsFixed(0)} ${AppStrings.pounds} (${point.ordersCount} ${AppStrings.orders})',
                AppTextStyles.font11Bold.copyWith(color: AppPalette.white),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppPalette.primaryGreen,
            barWidth: 3.w,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: dataPoints.length <= 10,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 4.r,
                    color: AppPalette.primaryGreen,
                    strokeWidth: 2.w,
                    strokeColor: AppPalette.white,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppPalette.primaryGreen.withValues(alpha: 0.28),
                  AppPalette.primaryGreen.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculates human-friendly intervals for chart axes (e.g. 25, 50, 100, 250, 500, 1000)
  static double _calculateNiceInterval(double rawInterval) {
    if (rawInterval <= 0) return 25.0;
    if (rawInterval <= 25) return 25.0;
    if (rawInterval <= 50) return 50.0;
    if (rawInterval <= 100) return 100.0;
    if (rawInterval <= 250) return 250.0;
    if (rawInterval <= 500) return 500.0;
    if (rawInterval <= 1000) return 1000.0;
    if (rawInterval <= 2500) return 2500.0;
    if (rawInterval <= 5000) return 5000.0;
    return (rawInterval / 1000).ceil() * 1000.0;
  }
}
