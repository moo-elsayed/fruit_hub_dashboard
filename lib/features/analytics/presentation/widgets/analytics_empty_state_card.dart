import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class AnalyticsEmptyStateCard extends StatelessWidget {
  const AnalyticsEmptyStateCard({
    super.key,
    this.message,
    this.verticalPadding,
  });

  final String? message;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 20.h),
      child: Text(
        message ?? AppStrings.noOrdersYet,
        style: AppTextStyles.font13Medium.copyWith(
          color: context.colors.subText,
        ),
      ),
    ),
  );
}
