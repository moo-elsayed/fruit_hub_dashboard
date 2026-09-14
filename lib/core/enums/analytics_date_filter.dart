import 'package:flutter/material.dart';

import '../helpers/app_strings.dart';

enum AnalyticsDateFilter {
  last7Days,
  last30Days,
  thisMonth,
  custom;

  String get title => switch (this) {
    AnalyticsDateFilter.last7Days => AppStrings.last7Days,
    AnalyticsDateFilter.last30Days => AppStrings.last30Days,
    AnalyticsDateFilter.thisMonth => AppStrings.thisMonth,
    AnalyticsDateFilter.custom => AppStrings.customRange,
  };

  DateTimeRange getDateRange({DateTimeRange? customRange}) {
    final now = DateTime.now();
    return switch (this) {
      AnalyticsDateFilter.last7Days => DateTimeRange(
        start: now.subtract(const Duration(days: 6)),
        end: now,
      ),
      AnalyticsDateFilter.last30Days => DateTimeRange(
        start: now.subtract(const Duration(days: 29)),
        end: now,
      ),
      AnalyticsDateFilter.thisMonth => DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now,
      ),
      AnalyticsDateFilter.custom =>
        customRange ??
            DateTimeRange(
              start: now.subtract(const Duration(days: 6)),
              end: now,
            ),
    };
  }
}
