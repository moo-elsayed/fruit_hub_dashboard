import '../../domain/entities/analytics_data_entity.dart';
import 'analytics_kpi_model.dart';
import 'order_status_stat_model.dart';
import 'payment_method_stat_model.dart';
import 'revenue_data_point_model.dart';
import 'top_product_model.dart';

class AnalyticsDataModel {
  const AnalyticsDataModel({
    this.kpi = const AnalyticsKpiModel(),
    this.revenueOverTime = const [],
    this.topProducts = const [],
    this.orderStatusStats = const [],
    this.paymentMethodStats = const [],
  });

  factory AnalyticsDataModel.fromJson(
    Map<String, dynamic> json,
  ) => AnalyticsDataModel(
    kpi: json['kpi'] != null
        ? AnalyticsKpiModel.fromSummaryJson(
            json['kpi'] as Map<String, dynamic>,
            totalUsers:
                (json['kpi'] as Map<String, dynamic>)['totalUsers'] as int? ??
                0,
            verifiedUsers:
                (json['kpi'] as Map<String, dynamic>)['verifiedUsers']
                    as int? ??
                0,
            activeCartsCount:
                (json['kpi'] as Map<String, dynamic>)['activeCartsCount']
                    as int? ??
                0,
          )
        : const AnalyticsKpiModel(),
    revenueOverTime:
        (json['revenueOverTime'] as List<dynamic>?)
            ?.map(
              (e) => RevenueDataPointModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const [],
    topProducts:
        (json['topProducts'] as List<dynamic>?)
            ?.map((e) => TopProductModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    orderStatusStats:
        (json['orderStatusStats'] as List<dynamic>?)
            ?.map(
              (e) => OrderStatusStatModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const [],
    paymentMethodStats:
        (json['paymentMethodStats'] as List<dynamic>?)
            ?.map(
              (e) => PaymentMethodStatModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const [],
  );

  factory AnalyticsDataModel.fromEntity(AnalyticsDataEntity entity) =>
      AnalyticsDataModel(
        kpi: AnalyticsKpiModel.fromEntity(entity.kpi),
        revenueOverTime: entity.revenueOverTime
            .map(RevenueDataPointModel.fromEntity)
            .toList(),
        topProducts: entity.topProducts
            .map(TopProductModel.fromEntity)
            .toList(),
        orderStatusStats: entity.orderStatusStats
            .map(OrderStatusStatModel.fromEntity)
            .toList(),
        paymentMethodStats: entity.paymentMethodStats
            .map(PaymentMethodStatModel.fromEntity)
            .toList(),
      );

  final AnalyticsKpiModel kpi;
  final List<RevenueDataPointModel> revenueOverTime;
  final List<TopProductModel> topProducts;
  final List<OrderStatusStatModel> orderStatusStats;
  final List<PaymentMethodStatModel> paymentMethodStats;

  Map<String, dynamic> toJson() => {
    'kpi': kpi.toJson(),
    'revenueOverTime': revenueOverTime.map((e) => e.toJson()).toList(),
    'topProducts': topProducts.map((e) => e.toJson()).toList(),
    'orderStatusStats': orderStatusStats.map((e) => e.toJson()).toList(),
    'paymentMethodStats': paymentMethodStats.map((e) => e.toJson()).toList(),
  };

  AnalyticsDataEntity toEntity() => AnalyticsDataEntity(
    kpi: kpi.toEntity(),
    revenueOverTime: revenueOverTime.map((e) => e.toEntity()).toList(),
    topProducts: topProducts.map((e) => e.toEntity()).toList(),
    orderStatusStats: orderStatusStats.map((e) => e.toEntity()).toList(),
    paymentMethodStats: paymentMethodStats.map((e) => e.toEntity()).toList(),
  );
}
