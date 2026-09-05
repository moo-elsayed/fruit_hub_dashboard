import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

import '../entities/bottom_sheet_selection_item_entity.dart';
import '../theming/app_text_styles.dart';

class BottomSheetSelectionItem extends StatelessWidget {
  const BottomSheetSelectionItem({super.key, required this.entity});

  final BottomSheetSelectionItemEntity entity;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: entity.onTap,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: entity.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: entity.isSelected
            ? Border.all(color: entity.color, width: 1.5)
            : Border.all(color: Colors.transparent),
      ),
      child: Text(
        entity.title,
        style: entity.isSelected
            ? AppTextStyles.font13SemiBold.copyWith(
                color: context.colors.mainText,
              )
            : AppTextStyles.font13SemiBold.copyWith(
                color: context.colors.subText,
              ),
      ),
    ),
  );
}
