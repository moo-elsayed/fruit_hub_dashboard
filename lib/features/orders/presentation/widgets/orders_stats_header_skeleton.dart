import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'orders_stats_header.dart';

class OrdersStatsHeaderSkeleton extends StatelessWidget {
  const OrdersStatsHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Skeletonizer(
    enabled: true,
    child: OrdersStatsHeader(
      stats: OrdersStatsEntity(
        totalCount: 88,
        pendingCount: 12,
        processingCount: 10,
        shippedCount: 15,
        deliveredCount: 45,
        cancelledCount: 6,
      ),
      activeFilter: null,
      onSelectFilter: _noop,
    ),
  );

  static void _noop(OrderStatus? _) {}
}
