import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

import '../../../../core/helpers/app_strings.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_count_badge.dart';

class DashboardQuickActionsHeader extends StatelessWidget {
  const DashboardQuickActionsHeader({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final _ = EasyLocalization.of(context)?.locale;

    return Row(
      spacing: 8.w,
      children: [
        Text(
          AppStrings.quickActions,
          style: AppTextStyles.font16Bold.copyWith(
            color: context.colors.mainText,
          ),
        ),
        CustomCountBadge(count: itemCount),
      ],
    );
  }
}
