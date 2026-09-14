import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_kpi_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/order_status_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/payment_method_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/revenue_data_point_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/top_product_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'analytics_kpi_section.dart';
import 'order_status_distribution_card.dart';
import 'payment_methods_card.dart';
import 'revenue_timeline_chart_card.dart';
import 'top_selling_products_card.dart';

class AnalyticsSkeletonBody extends StatelessWidget {
  const AnalyticsSkeletonBody({super.key});

  static final _mockData = AnalyticsDataEntity(
    kpi: const AnalyticsKpiEntity(
      totalRevenue: 12500,
      totalOrders: 45,
      totalUsers: 120,
      verifiedUsers: 85,
      activeCartsCount: 14,
    ),
    revenueOverTime: [
      RevenueDataPointEntity(
        date: DateTime(2026, 9, 1),
        revenue: 1200,
        ordersCount: 5,
      ),
      RevenueDataPointEntity(
        date: DateTime(2026, 9, 2),
        revenue: 2400,
        ordersCount: 8,
      ),
      RevenueDataPointEntity(
        date: DateTime(2026, 9, 3),
        revenue: 1800,
        ordersCount: 6,
      ),
    ],
    orderStatusStats: const [
      OrderStatusStatEntity(status: OrderStatus.delivered, count: 25),
      OrderStatusStatEntity(status: OrderStatus.processing, count: 10),
      OrderStatusStatEntity(status: OrderStatus.shipped, count: 6),
      OrderStatusStatEntity(status: OrderStatus.cancelled, count: 4),
    ],
    paymentMethodStats: const [
      PaymentMethodStatEntity(type: PaymentMethodType.cash, count: 20),
      PaymentMethodStatEntity(type: PaymentMethodType.card, count: 18),
      PaymentMethodStatEntity(type: PaymentMethodType.paypal, count: 7),
    ],
    topProducts: const [
      TopProductEntity(
        code: '101',
        name: 'تفاح أحمر سكري فاخر',
        imagePath: '',
        totalQuantitySold: 30,
        totalRevenue: 600,
      ),
      TopProductEntity(
        code: '102',
        name: 'موز إكوادوري طازج',
        imagePath: '',
        totalQuantitySold: 25,
        totalRevenue: 450,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: true,
    child: ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AnalyticsKpiSection(kpi: _mockData.kpi),
        const SizedBox(height: 16),
        RevenueTimelineChartCard(dataPoints: _mockData.revenueOverTime),
        const SizedBox(height: 16),
        OrderStatusDistributionCard(statusStats: _mockData.orderStatusStats),
        const SizedBox(height: 16),
        PaymentMethodsCard(paymentMethodStats: _mockData.paymentMethodStats),
        const SizedBox(height: 16),
        TopSellingProductsCard(topProducts: _mockData.topProducts),
      ],
    ),
  );
}
