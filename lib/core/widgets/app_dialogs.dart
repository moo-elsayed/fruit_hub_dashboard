import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../theming/app_text_styles.dart';

abstract class AppDialogs {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: .symmetric(horizontal: 48.w),
            child: Container(
              padding: .symmetric(vertical: 24.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child: CupertinoActivityIndicator(radius: 14.r),
                  ),
                  Gap(16.h),
                  Text(
                    'loading',
                    style: AppTextStyles.font13color0C0D0DSemiBold,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
