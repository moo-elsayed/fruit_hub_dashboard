import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheetTopContainer extends StatelessWidget {
  const CustomBottomSheetTopContainer({super.key, this.margin = 8});

  final int margin;

  @override
  Widget build(BuildContext context) => Container(
      width: 60.w,
      height: 4.h,
      margin: .only(bottom: margin.h),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.5),
        borderRadius: .circular(16),
      ),
    );
}