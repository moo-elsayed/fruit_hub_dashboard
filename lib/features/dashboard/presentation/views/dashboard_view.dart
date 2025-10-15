import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: CustomMaterialButton(
          onPressed: () => context.pushNamed(Routes.addProductView),
          text: "Add product",
          textStyle: AppTextStyles.font16WhiteBold,
        ),
      ),
    );
  }
}
