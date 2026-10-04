import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';

class ProductActionButton extends StatelessWidget {
  const ProductActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.iconColor,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.isCircle = true,
    this.backgroundColor,
    this.borderColor,
    this.hasShadow = true,
  });

  const ProductActionButton.delete({
    super.key,
    required this.onTap,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.isCircle = false,
    this.backgroundColor,
    this.borderColor,
    this.hasShadow = false,
  }) : icon = Icons.delete_outline_rounded,
       iconColor = null;

  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final double? borderRadius;
  final bool isCircle;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? context.colors.error;
    final effectiveBgColor =
        backgroundColor ??
        (iconColor == null
            ? context.colors.error.withValues(alpha: 0.08)
            : context.colors.surface);
    final effectiveBorderColor =
        borderColor ??
        (iconColor == null
            ? context.colors.error.withValues(alpha: 0.2)
            : context.colors.surface);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveBgColor,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle
            ? null
            : BorderRadius.circular((borderRadius ?? 8).r),
        border: Border.all(color: effectiveBorderColor, width: 1.w),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppPalette.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: AppPalette.transparent,
        shape: isCircle ? const CircleBorder() : null,
        child: InkWell(
          onTap: onTap,
          customBorder: isCircle ? const CircleBorder() : null,
          borderRadius: isCircle
              ? null
              : BorderRadius.circular((borderRadius ?? 8).r),
          child: Padding(
            padding: padding ?? EdgeInsets.all(isCircle ? 7.r : 4.r),
            child: Icon(
              icon,
              color: effectiveIconColor,
              size: (iconSize ?? 18).sp,
            ),
          ),
        ),
      ),
    );
  }
}
