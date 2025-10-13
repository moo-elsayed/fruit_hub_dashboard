import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.color2D9F5D,
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: AppTextStyles.font19WhiteBold),
    );
  }
}
