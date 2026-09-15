import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet_handle.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';

class CupertinoDateRangePickerSheet extends StatefulWidget {
  const CupertinoDateRangePickerSheet({
    super.key,
    required this.initialRange,
    required this.firstDate,
    required this.lastDate,
    required this.onConfirmed,
  });

  final DateTimeRange initialRange;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTimeRange> onConfirmed;

  static Future<void> show({
    required BuildContext context,
    required DateTimeRange initialRange,
    required DateTime firstDate,
    required DateTime lastDate,
    required ValueChanged<DateTimeRange> onConfirmed,
  }) => showModalBottomSheet(
    context: context,
    backgroundColor: AppPalette.transparent,
    isScrollControlled: true,
    builder: (context) => CupertinoDateRangePickerSheet(
      initialRange: initialRange,
      firstDate: firstDate,
      lastDate: lastDate,
      onConfirmed: onConfirmed,
    ),
  );

  @override
  State<CupertinoDateRangePickerSheet> createState() =>
      _CupertinoDateRangePickerSheetState();
}

class _CupertinoDateRangePickerSheetState
    extends State<CupertinoDateRangePickerSheet> {
  late final ValueNotifier<DateTime> _startDateNotifier;
  late final ValueNotifier<DateTime> _endDateNotifier;
  final ValueNotifier<int> _selectedTabNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _startDateNotifier = ValueNotifier<DateTime>(widget.initialRange.start);
    _endDateNotifier = ValueNotifier<DateTime>(widget.initialRange.end);
  }

  @override
  void dispose() {
    _startDateNotifier.dispose();
    _endDateNotifier.dispose();
    _selectedTabNotifier.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final start = _startDateNotifier.value;
    final end = _endDateNotifier.value;
    // If user set start after end, swap them gracefully
    final finalStart = start.isBefore(end) ? start : end;
    final finalEnd = start.isBefore(end) ? end : start;

    widget.onConfirmed(DateTimeRange(start: finalStart, end: finalEnd));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppPalette.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomBottomSheetHandle(),
          SizedBox(height: 12.h),
          Text(
            AppStrings.selectDateRange,
            style: AppTextStyles.font16Bold.copyWith(color: colors.mainText),
          ),
          SizedBox(height: 16.h),
          ValueListenableBuilder<int>(
            valueListenable: _selectedTabNotifier,
            builder: (context, activeIndex, _) => Row(
              spacing: 12.w,
              children: [
                Expanded(
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _startDateNotifier,
                    builder: (context, startDate, _) => _DateSelectorTab(
                      label: AppStrings.startDate,
                      date: startDate,
                      isActive: activeIndex == 0,
                      onTap: () => _selectedTabNotifier.value = 0,
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _endDateNotifier,
                    builder: (context, endDate, _) => _DateSelectorTab(
                      label: AppStrings.endDate,
                      date: endDate,
                      isActive: activeIndex == 1,
                      onTap: () => _selectedTabNotifier.value = 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 180.h,
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedTabNotifier,
              builder: (context, activeIndex, _) {
                final isStart = activeIndex == 0;
                final currentDate = isStart
                    ? _startDateNotifier.value
                    : _endDateNotifier.value;

                return CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: context.isDarkMode
                        ? Brightness.dark
                        : Brightness.light,
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: AppTextStyles.font16Medium
                          .copyWith(color: colors.mainText),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    key: ValueKey<int>(activeIndex),
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: currentDate,
                    minimumDate: widget.firstDate,
                    maximumDate: widget.lastDate,
                    onDateTimeChanged: (date) {
                      if (isStart) {
                        _startDateNotifier.value = date;
                      } else {
                        _endDateNotifier.value = date;
                      }
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          CustomMaterialButton(
            maxWidth: true,
            text: AppStrings.apply,
            onPressed: _onConfirm,
          ),
        ],
      ),
    );
  }
}

class _DateSelectorTab extends StatelessWidget {
  const _DateSelectorTab({
    required this.label,
    required this.date,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = colors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive ? primary.withValues(alpha: 0.1) : colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isActive ? primary : colors.border,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            Text(
              label,
              style: AppTextStyles.font11Regular.copyWith(
                color: isActive ? primary : colors.subText,
              ),
            ),
            Text(
              DateFormat('d MMM yyyy').format(date),
              style: AppTextStyles.font13Bold.copyWith(
                color: isActive ? primary : colors.mainText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
