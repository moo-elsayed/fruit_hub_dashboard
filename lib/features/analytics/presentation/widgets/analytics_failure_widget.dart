import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';

import '../managers/analytics_cubit/analytics_cubit.dart';

class AnalyticsFailureWidget extends StatelessWidget {
  const AnalyticsFailureWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.r,
            color: context.colors.error,
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: AppTextStyles.font14Medium.copyWith(
              color: context.colors.mainText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          CustomMaterialButton(
            onPressed: () => context.read<AnalyticsCubit>().refresh(),
            text: AppStrings.retry,
            maxWidth: false,
          ),
        ],
      ),
    ),
  );
}
