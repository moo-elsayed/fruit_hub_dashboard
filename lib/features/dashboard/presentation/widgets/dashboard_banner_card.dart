import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';

class DashboardBannerCard extends StatelessWidget {
  const DashboardBannerCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(20.r),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppPalette.primaryGreen, AppPalette.secondaryGreen],
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      ),
      borderRadius: BorderRadius.circular(24.r),
      boxShadow: [
        BoxShadow(
          color: AppPalette.primaryGreen.withValues(alpha: 0.28),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Stack(
      children: [
        PositionedDirectional(
          end: -15.w,
          bottom: -20.h,
          child: Icon(
            Icons.storefront_rounded,
            size: 110.sp,
            color: AppPalette.white.withValues(alpha: 0.12),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppPalette.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: const BoxDecoration(
                      color: AppPalette.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(6.w),
                  Text(
                    AppStrings.storeControlPanel,
                    style: AppTextStyles.font11SemiBold.copyWith(
                      color: AppPalette.white,
                    ),
                  ),
                ],
              ),
            ),
            Gap(12.h),
            Text(
              AppStrings.welcomeToDashboard,
              style: AppTextStyles.font18Bold.copyWith(
                color: AppPalette.white,
                height: 1.2,
              ),
            ),
            Gap(6.h),
            Text(
              AppStrings.controlPanelSubtitle,
              style: AppTextStyles.font12Regular.copyWith(
                color: AppPalette.white.withValues(alpha: 0.85),
                height: 1.4,
              ),
            ),
          ],
        ),
      ],
    ),
  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.08, duration: 400.ms);
}
