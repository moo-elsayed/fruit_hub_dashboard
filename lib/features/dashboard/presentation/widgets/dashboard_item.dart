import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';
import '../../domain/entities/entities/dashboard_item_entity.dart';

class DashboardItem extends StatelessWidget {
  const DashboardItem({super.key, required this.entity});

  final DashboardItemEntity entity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: entity.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: entity.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: entity.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(entity.icon, size: 40.sp, color: entity.color),
            Gap(12.h),
            Text(
              entity.title,
              style: AppTextStyles.font16WhiteBold.copyWith(
                color: entity.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
