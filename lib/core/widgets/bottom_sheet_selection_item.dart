import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: .symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: entity.color.withValues(alpha: 0.1),
        borderRadius: .circular(24.r),
        border: entity.isSelected
            ? .all(color: entity.color, width: 1.5)
            : .all(color: Colors.transparent),
      ),
      child: Text(
        entity.title,
        style: entity.isSelected
            ? AppTextStyles.font13color0C0D0DSemiBold
            : AppTextStyles.font13color949D9ESemiBold,
      ),
    ),
  );
}
