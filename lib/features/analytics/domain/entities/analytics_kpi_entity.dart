import 'package:equatable/equatable.dart';

class AnalyticsKpiEntity extends Equatable {
  const AnalyticsKpiEntity({
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

  @override
  List<Object?> get props => [
    totalRevenue,
    totalOrders,
    deliveredOrders,
    cancelledOrders,
    pendingOrders,
    processingOrders,
    shippedOrders,
    totalUsers,
    verifiedUsers,
    activeCartsCount,
  ];
}
