import 'package:equatable/equatable.dart';

import 'analytics_kpi_entity.dart';
import 'order_status_stat_entity.dart';
import 'payment_method_stat_entity.dart';
import 'revenue_data_point_entity.dart';
import 'top_product_entity.dart';

class AnalyticsDataEntity extends Equatable {
  const AnalyticsDataEntity({
    this.kpi = const AnalyticsKpiEntity(),
    this.revenueOverTime = const [],
    this.topProducts = const [],
    this.orderStatusStats = const [],
    this.paymentMethodStats = const [],
  });

  final AnalyticsKpiEntity kpi;

  /// Daily data points sorted ascending by date.
  final List<RevenueDataPointEntity> revenueOverTime;

  /// Top 10 best-selling products sorted descending by quantity.
  final List<TopProductEntity> topProducts;

  /// One entry per [OrderStatus] value (including zeros).
  final List<OrderStatusStatEntity> orderStatusStats;

  /// One entry per [PaymentMethodType] value (including zeros).
  final List<PaymentMethodStatEntity> paymentMethodStats;

  @override
  List<Object?> get props => [
    kpi,
    revenueOverTime,
    topProducts,
    orderStatusStats,
    paymentMethodStats,
  ];
}
