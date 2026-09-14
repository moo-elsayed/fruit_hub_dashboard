import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';

import '../managers/analytics_cubit/analytics_cubit.dart';
import '../widgets/analytics_view_body.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocProvider<AnalyticsCubit>(
      create: (context) => getIt<AnalyticsCubit>()
        ..loadAnalytics(from: now.subtract(const Duration(days: 6)), to: now),
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.analytics,
          showArrowBack: true,
          onTap: () => context.pop(),
        ),
        body: const AnalyticsViewBody(),
      ),
    );
  }
}
