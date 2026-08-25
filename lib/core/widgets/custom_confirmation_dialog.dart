import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_assets.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:gap/gap.dart';
import '../theming/app_text_styles.dart';
import 'custom_material_button.dart';

class CustomConfirmationDialog extends StatelessWidget {
  const CustomConfirmationDialog({
    super.key,
    this.subtitle,
    required this.textConfirmButton,
    required this.textCancelButton,
    required this.title,
    required this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String? subtitle;
  final String textConfirmButton;
  final String textCancelButton;
  final void Function()? onCancel;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: context.colors.surface,
    child: Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.h,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: SvgPicture.asset(AppAssets.iconsIconCancel),
            ),
          ),
          Text(
            title,
            style: AppTextStyles.font16Bold.copyWith(
              color: context.colors.mainText,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppTextStyles.font13SemiBold.copyWith(
                color: context.colors.bodyText,
              ),
            ),
          Gap(8.h),
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: CustomMaterialButton(
                  onPressed: onCancel ?? () => context.pop(),
                  text: textCancelButton,
                  textStyle: AppTextStyles.font16Bold.copyWith(
                    color: context.colors.primary,
                  ),
                  backgroundColor: context.colors.surface,
                  side: BorderSide(color: context.colors.primary),
                ),
              ),
              Expanded(
                child: CustomMaterialButton(
                  onPressed: onConfirm,
                  text: textConfirmButton,
                  textStyle: AppTextStyles.font16Bold.copyWith(
                    color: AppPalette.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
