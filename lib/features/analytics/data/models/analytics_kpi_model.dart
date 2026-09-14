import '../../domain/entities/analytics_kpi_entity.dart';

class AnalyticsKpiModel {
  const AnalyticsKpiModel({
    this.totalRevenue = 0,
    this.totalOrders = 0,
    this.deliveredOrders = 0,
    this.cancelledOrders = 0,
    this.pendingOrders = 0,
    this.processingOrders = 0,
    this.shippedOrders = 0,
    this.totalUsers = 0,
    this.verifiedUsers = 0,
    this.activeCartsCount = 0,
  });

  /// Reads from the `analytics/summary` Firestore document.
  factory AnalyticsKpiModel.fromSummaryJson(
    Map<String, dynamic> json, {
    required int totalUsers,
    required int verifiedUsers,
    required int activeCartsCount,
  }) => AnalyticsKpiModel(
    totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
    totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
    deliveredOrders: (json['deliveredOrders'] as num?)?.toInt() ?? 0,
    cancelledOrders: (json['cancelledOrders'] as num?)?.toInt() ?? 0,
    pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
    processingOrders: (json['processingOrders'] as num?)?.toInt() ?? 0,
    shippedOrders: (json['shippedOrders'] as num?)?.toInt() ?? 0,
    totalUsers: totalUsers,
    verifiedUsers: verifiedUsers,
    activeCartsCount: activeCartsCount,
  );

  factory AnalyticsKpiModel.fromEntity(AnalyticsKpiEntity entity) =>
      AnalyticsKpiModel(
        totalRevenue: entity.totalRevenue,
        totalOrders: entity.totalOrders,
        deliveredOrders: entity.deliveredOrders,
        cancelledOrders: entity.cancelledOrders,
        pendingOrders: entity.pendingOrders,
        processingOrders: entity.processingOrders,
        shippedOrders: entity.shippedOrders,
        totalUsers: entity.totalUsers,
        verifiedUsers: entity.verifiedUsers,
        activeCartsCount: entity.activeCartsCount,
      );

  final double totalRevenue;
  final int totalOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int totalUsers;
  final int verifiedUsers;
  final int activeCartsCount;

  double get deliveryRate =>
      totalOrders == 0 ? 0 : (deliveredOrders / totalOrders) * 100;

  double get cancellationRate =>
      totalOrders == 0 ? 0 : (cancelledOrders / totalOrders) * 100;

  Map<String, dynamic> toJson() => {
    'totalRevenue': totalRevenue,
    'totalOrders': totalOrders,
    'deliveredOrders': deliveredOrders,
    'cancelledOrders': cancelledOrders,
    'pendingOrders': pendingOrders,
    'processingOrders': processingOrders,
    'shippedOrders': shippedOrders,
    'totalUsers': totalUsers,
    'verifiedUsers': verifiedUsers,
    'activeCartsCount': activeCartsCount,
  };

  AnalyticsKpiEntity toEntity() => AnalyticsKpiEntity(
    totalRevenue: totalRevenue,
    totalOrders: totalOrders,
    deliveredOrders: deliveredOrders,
    cancelledOrders: cancelledOrders,
    pendingOrders: pendingOrders,
    processingOrders: processingOrders,
    shippedOrders: shippedOrders,
    totalUsers: totalUsers,
    verifiedUsers: verifiedUsers,
    activeCartsCount: activeCartsCount,
  );
}
