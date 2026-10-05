import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class CustomCountBadge extends StatelessWidget {
  const CustomCountBadge({
    super.key,
    this.count,
    this.text,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.isCircle = false,
    this.textStyle,
  });

  const CustomCountBadge.quantity({
    super.key,
    required int quantity,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.isCircle = false,
    this.textStyle,
  })  : count = null,
        text = 'x$quantity';

  final int? count;
  final String? text;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isCircle;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
    decoration: BoxDecoration(
      color: backgroundColor ??
          (textColor ?? context.colors.primary).withValues(alpha: 0.1),
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: isCircle
          ? null
          : BorderRadius.circular(borderRadius ?? 10.r),
    ),
    child: Text(
      text ?? (count != null ? '$count' : ''),
      style: (textStyle ?? AppTextStyles.font12Bold).copyWith(
        color: textColor ?? context.colors.primary,
      ),
    ),
  );
}
