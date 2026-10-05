import 'package:fruit_hub_dashboard/core/enums/order_status.dart';

class OrdersStatsEntity {
  const OrdersStatsEntity({
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

  int countFor(OrderStatus? status) => switch (status) {
    null => totalCount,
    OrderStatus.pending => pendingCount,
    OrderStatus.processing => processingCount,
    OrderStatus.shipped => shippedCount,
    OrderStatus.delivered => deliveredCount,
    OrderStatus.cancelled => cancelledCount,
  };
}
