import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_dashboard_app_bar.dart';
import '../widgets/dashboard_view_body.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = EasyLocalization.of(context)?.locale;

    return const Scaffold(
      appBar: CustomDashboardAppBar(),
      body: DashboardViewBody(),
    );
  }
}
