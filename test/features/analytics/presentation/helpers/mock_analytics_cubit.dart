import 'package:bloc_test/bloc_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_kpi_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/order_status_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/payment_method_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/revenue_data_point_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/top_product_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/managers/analytics_cubit/analytics_cubit.dart';

class MockAnalyticsCubit extends MockCubit<AnalyticsState>
    implements AnalyticsCubit {}

AnalyticsDataEntity getDummyAnalyticsData() => AnalyticsDataEntity(
  kpi: const AnalyticsKpiEntity(
    totalRevenue: 24500,
    totalOrders: 65,
    totalUsers: 140,
    verifiedUsers: 95,
    activeCartsCount: 18,
    deliveredOrders: 40,
    cancelledOrders: 5,
    pendingOrders: 10,
    processingOrders: 8,
    shippedOrders: 2,
  ),
  revenueOverTime: [
    RevenueDataPointEntity(
      date: DateTime(2026, 9, 1),
      revenue: 1200,
      ordersCount: 4,
    ),
    RevenueDataPointEntity(
      date: DateTime(2026, 9, 2),
      revenue: 2500,
      ordersCount: 8,
    ),
  ],
  orderStatusStats: const [
    OrderStatusStatEntity(status: OrderStatus.delivered, count: 40),
    OrderStatusStatEntity(status: OrderStatus.pending, count: 10),
  ],
  paymentMethodStats: const [
    PaymentMethodStatEntity(type: PaymentMethodType.cash, count: 35),
    PaymentMethodStatEntity(type: PaymentMethodType.card, count: 25),
    PaymentMethodStatEntity(type: PaymentMethodType.paypal, count: 5),
  ],
  topProducts: const [
    TopProductEntity(
      code: '001',
      name: 'تفاح أحمر',
      imagePath: 'https://storage/apple.jpg',
      totalQuantitySold: 30,
      totalRevenue: 1500,
    ),
  ],
);
