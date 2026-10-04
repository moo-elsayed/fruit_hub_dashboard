import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class ProductImagePickerEmptyCard extends StatelessWidget {
  const ProductImagePickerEmptyCard({
    super.key,
    required this.onTap,
    this.hasError = false,
  });

  final VoidCallback onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: hasError ? context.colors.error : context.colors.border,
          width: hasError ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppPalette.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.h,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_photo_alternate_rounded,
              color: context.colors.primary,
              size: 28.sp,
            ),
          ),
          Text(
            AppStrings.productImage,
            style: AppTextStyles.font14SemiBold.copyWith(
              color: context.colors.mainText,
            ),
          ),
          Text(
            AppStrings.pleaseSelectImage,
            style: AppTextStyles.font12Regular.copyWith(
              color: context.colors.subText,
            ),
          ),
        ],
      ),
    ),
  );
}
