import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/analytics_date_filter.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

import '../managers/analytics_cubit/analytics_cubit.dart';
import 'cupertino_date_range_picker_sheet.dart';

class AnalyticsDateFilterBar extends StatelessWidget {
  const AnalyticsDateFilterBar({
    super.key,
    required this.selectedFilter,
    required this.customRangeNotifier,
  });

  final ValueNotifier<AnalyticsDateFilter> selectedFilter;
  final ValueNotifier<DateTimeRange?> customRangeNotifier;

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<AnalyticsDateFilter>(
        valueListenable: selectedFilter,
        builder: (context, current, _) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8.w,
            children: AnalyticsDateFilter.values.map((filter) {
              final isSelected = filter == current;
              return _FilterChip(
                label: filter.title,
                isSelected: isSelected,
                onTap: () => _onFilterSelected(context, filter),
              );
            }).toList(),
          ),
        ),
      );

  void _onFilterSelected(BuildContext context, AnalyticsDateFilter filter) {
    if (filter == AnalyticsDateFilter.custom) {
      _pickCustomDateRange(context);
      return;
    }

    final range = filter.getDateRange();
    selectedFilter.value = filter;
    context.read<AnalyticsCubit>().loadAnalytics(
      from: range.start,
      to: range.end,
    );
  }

  Future<void> _pickCustomDateRange(BuildContext context) async {
    final now = DateTime.now();
    final cubit = context.read<AnalyticsCubit>();

    // Use previously selected custom range if exists, otherwise default to last 7 days
    final initialRange =
        customRangeNotifier.value ??
        DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now);

    await CupertinoDateRangePickerSheet.show(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialRange: initialRange,
      onConfirmed: (picked) {
        customRangeNotifier.value = picked;
        selectedFilter.value = AnalyticsDateFilter.custom;
        cubit.loadAnalytics(from: picked.start, to: picked.end);
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20.r),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.primary : context.colors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? context.colors.primary : context.colors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.font12Medium.copyWith(
          color: isSelected ? AppPalette.white : context.colors.mainText,
        ),
      ),
    ),
  );
}
