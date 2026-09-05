import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/helpers/validator.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/text_form_field_helper.dart';
import 'package:gap/gap.dart';

class SettingsCurrencyField extends StatelessWidget {
  const SettingsCurrencyField({
    super.key,
    required this.title,
    required this.controller,
    this.subtitle,
    this.hint,
  });

  final String title;
  final String? subtitle;
  final String? hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyles.font14Bold.copyWith(
          color: context.colors.mainText,
        ),
      ),
      if (subtitle != null) ...[
        Gap(4.h),
        Text(
          subtitle!,
          style: AppTextStyles.font11Regular.copyWith(
            color: context.colors.subText,
          ),
        ),
      ],
      Gap(8.h),
      TextFormFieldHelper(
        controller: controller,
        onValidate: Validator.validateRequiredField,
        hint: hint,
        suffixWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.egp,
              style: AppTextStyles.font13Medium.copyWith(
                color: context.colors.subText,
              ),
            ),
          ],
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    ],
  );
}
