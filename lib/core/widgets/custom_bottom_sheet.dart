import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import '../entities/bottom_sheet_selection_item_entity.dart';
import '../theming/app_text_styles.dart';
import 'bottom_sheet_selection_item.dart';
import 'custom_bottom_sheet_top_container.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<BottomSheetSelectionItemEntity> items;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12.h,
      children: [
        const CustomBottomSheetTopContainer(margin: 0),
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            title,
            style: AppTextStyles.font16Bold.copyWith(
              color: context.colors.mainText,
            ),
          ),
        ),
        ...List.generate(
          items.length,
          (index) => BottomSheetSelectionItem(entity: items[index]),
        ),
      ],
    ),
  );
}
