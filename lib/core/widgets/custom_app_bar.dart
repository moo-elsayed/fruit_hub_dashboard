import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

import '../theming/app_text_styles.dart';
import 'custom_arrow_back.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showArrowBack = false,
    this.centerTitle = true,
    this.onTap,
    this.actions,
    this.backgroundColor,
  });

  final String title;
  final bool showArrowBack;
  final VoidCallback? onTap;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  @override
  Widget build(BuildContext context) => AppBar(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: backgroundColor ?? Colors.transparent,
    leadingWidth: showArrowBack ? 60.w : null,
    leading: showArrowBack
        ? Padding(
            padding: EdgeInsetsDirectional.only(start: 16.w),
            child: Center(child: CustomArrowBack(onTap: onTap)),
          )
        : null,
    title: Text(
      title,
      style: AppTextStyles.font19Bold.copyWith(color: context.colors.mainText),
    ),
    centerTitle: centerTitle,
    actions: actions,
  );
}
