import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/analytics_date_filter.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

import '../managers/analytics_cubit/analytics_cubit.dart';
import 'analytics_date_filter_bar.dart';
import 'analytics_failure_widget.dart';
import 'analytics_kpi_section.dart';
import 'analytics_skeleton_body.dart';
import 'order_status_distribution_card.dart';
import 'payment_methods_card.dart';
import 'revenue_timeline_chart_card.dart';
import 'top_selling_products_card.dart';

class AnalyticsViewBody extends StatefulWidget {
  const AnalyticsViewBody({super.key});

  @override
  State<AnalyticsViewBody> createState() => _AnalyticsViewBodyState();
}

class _AnalyticsViewBodyState extends State<AnalyticsViewBody> {
  late final ValueNotifier<AnalyticsDateFilter> _selectedFilter;
  late final ValueNotifier<DateTimeRange?> _customRangeNotifier;

  @override
  void initState() {
    super.initState();
    _selectedFilter = ValueNotifier(AnalyticsDateFilter.last7Days);
    _customRangeNotifier = ValueNotifier<DateTimeRange?>(null);
  }

  @override
  void dispose() {
    _selectedFilter.dispose();
    _customRangeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(height: 12.h),
      AnalyticsDateFilterBar(
        selectedFilter: _selectedFilter,
        customRangeNotifier: _customRangeNotifier,
      ),
      SizedBox(height: 8.h),
      Expanded(
        child: RefreshIndicator(
          onRefresh: () => context.read<AnalyticsCubit>().refresh(),
          color: context.colors.primary,
          child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
            builder: (context, state) => switch (state) {
              AnalyticsLoading() ||
              AnalyticsInitial() => const AnalyticsSkeletonBody(),
              AnalyticsFailure(:final message) => AnalyticsFailureWidget(
                message: message,
              ),
              AnalyticsSuccess(:final data) => ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  AnalyticsKpiSection(kpi: data.kpi),
                  SizedBox(height: 16.h),
                  RevenueTimelineChartCard(dataPoints: data.revenueOverTime),
                  SizedBox(height: 16.h),
                  OrderStatusDistributionCard(
                    statusStats: data.orderStatusStats,
                  ),
                  SizedBox(height: 16.h),
                  PaymentMethodsCard(
                    paymentMethodStats: data.paymentMethodStats,
                  ),
                  SizedBox(height: 16.h),
                  TopSellingProductsCard(topProducts: data.topProducts),
                  SizedBox(height: 24.h),
                ],
              ),
            },
          ),
        ),
      ),
    ],
  );
}
