import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class UserFavoritesList extends StatelessWidget {
  const UserFavoritesList({super.key, required this.favoriteIds});

  final List<String> favoriteIds;

  @override
  Widget build(BuildContext context) {
    if (favoriteIds.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 36.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.h,
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 40.sp,
                color: context.colors.subText,
              ),
              Text(
                AppStrings.emptyFavorites,
                style: AppTextStyles.font14Medium.copyWith(
                  color: context.colors.subText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: favoriteIds.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final code = favoriteIds[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                  color: AppPalette.accentPink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 20.sp,
                  color: AppPalette.accentPink,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.h,
                  children: [
                    Text(
                      '${AppStrings.productCode}: $code',
                      style: AppTextStyles.font13SemiBold.copyWith(
                        color: context.colors.mainText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
