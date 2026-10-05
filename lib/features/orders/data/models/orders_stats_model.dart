import '../../domain/entities/orders_stats_entity.dart';

class OrdersStatsModel {
  const OrdersStatsModel({
    this.totalCount = 0,
    this.pendingCount = 0,
    this.processingCount = 0,
    this.shippedCount = 0,
    this.deliveredCount = 0,
    this.cancelledCount = 0,
  });

  final int totalCount;
  final int pendingCount;
  final int processingCount;
  final int shippedCount;
  final int deliveredCount;
  final int cancelledCount;

  OrdersStatsEntity toEntity() => OrdersStatsEntity(
    totalCount: totalCount,
    pendingCount: pendingCount,
    processingCount: processingCount,
    shippedCount: shippedCount,
    deliveredCount: deliveredCount,
    cancelledCount: cancelledCount,
  );
}
