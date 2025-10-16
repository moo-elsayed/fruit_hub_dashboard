import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../../../../core/theming/app_text_styles.dart';

class CustomDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            'Welcome to dashboard',
            textStyle: AppTextStyles.font19color0C0D0DBold,
            speed: const Duration(milliseconds: 200),
          ),
        ],
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 1000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      ),
      centerTitle: true,
    );
  }
}