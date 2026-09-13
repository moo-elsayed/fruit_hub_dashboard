import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';

class ShippingNotificationToggleTile extends StatelessWidget {
  const ShippingNotificationToggleTile({
    super.key,
    required this.notifyNotifier,
    required this.costController,
    required this.thresholdController,
  });

  final ValueNotifier<bool> notifyNotifier;
  final TextEditingController costController;
  final TextEditingController thresholdController;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: notifyNotifier,
    builder: (context, notify, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.notifications_active_outlined,
                  size: 20.sp,
                  color: context.colors.primary,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.h,
                  children: [
                    Text(
                      AppStrings.notifyUsersAboutShippingUpdate,
                      style: AppTextStyles.font13SemiBold.copyWith(
                        color: context.colors.mainText,
                      ),
                    ),
                    Text(
                      AppStrings.notifyUsersAboutShippingUpdateSubtitle,
                      style: AppTextStyles.font11Regular.copyWith(
                        color: context.colors.subText,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: notify,
                activeTrackColor: context.colors.primary,
                onChanged: (val) => notifyNotifier.value = val,
              ),
            ],
          ),
        ),
        if (notify) ...[
          Gap(10.h),
          ListenableBuilder(
            listenable: Listenable.merge([costController, thresholdController]),
            builder: (context, _) {
              final cost = double.tryParse(costController.text.trim()) ?? 0.0;
              final threshold =
                  double.tryParse(thresholdController.text.trim()) ?? 0.0;
              final bodyAr = AppStrings.shippingUpdateBodyAr(
                cost: cost,
                threshold: threshold,
              );
              final bodyEn = AppStrings.shippingUpdateBodyEn(
                cost: cost,
                threshold: threshold,
              );

              return Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.colors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6.h,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 14.sp,
                          color: context.colors.primary,
                        ),
                        Gap(6.w),
                        Text(
                          AppStrings.notificationPreview,
                          style: AppTextStyles.font12SemiBold.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppStrings.shippingUpdateTitleAr,
                      style: AppTextStyles.font12Bold.copyWith(
                        color: context.colors.mainText,
                      ),
                    ),
                    Text(
                      bodyAr,
                      style: AppTextStyles.font11Regular.copyWith(
                        color: context.colors.bodyText,
                      ),
                    ),
                    Divider(
                      height: 12.h,
                      color: context.colors.border.withValues(alpha: 0.5),
                    ),
                    Text(
                      AppStrings.shippingUpdateTitleEn,
                      style: AppTextStyles.font12Bold.copyWith(
                        color: context.colors.mainText,
                      ),
                    ),
                    Text(
                      bodyEn,
                      style: AppTextStyles.font11Regular.copyWith(
                        color: context.colors.bodyText,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    ),
  );
}
