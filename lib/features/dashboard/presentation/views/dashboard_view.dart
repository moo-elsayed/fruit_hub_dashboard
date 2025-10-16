import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import '../widgets/custom_dashboard_app_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomDashboardAppBar(),
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
