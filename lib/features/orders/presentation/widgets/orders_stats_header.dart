import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/utils/stat_filter_tab_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/stat_filter_tab.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';

class OrdersStatsHeader extends StatelessWidget {
  const OrdersStatsHeader({
    super.key,
    required this.stats,
    required this.activeFilter,
    required this.onSelectFilter,
  });

  final OrdersStatsEntity stats;
  final OrderStatus? activeFilter;
  final ValueChanged<OrderStatus?> onSelectFilter;

  List<StatFilterTabItem> get _items => [
    StatFilterTabItem(
      title: AppStrings.all,
      count: stats.totalCount,
      icon: Icons.receipt_long_rounded,
      color: AppPalette.info,
      isSelected: activeFilter == null,
      onTap: () => onSelectFilter(null),
    ),
    StatFilterTabItem(
      title: AppStrings.statusPending,
      count: stats.pendingCount,
      icon: Icons.pending_actions_rounded,
      color: AppPalette.warning,
      isSelected: activeFilter == OrderStatus.pending,
      onTap: () => onSelectFilter(OrderStatus.pending),
    ),
    StatFilterTabItem(
      title: AppStrings.statusProcessing,
      count: stats.processingCount,
      icon: Icons.sync_rounded,
      color: AppPalette.info,
      isSelected: activeFilter == OrderStatus.processing,
      onTap: () => onSelectFilter(OrderStatus.processing),
    ),
    StatFilterTabItem(
      title: AppStrings.statusShipped,
      count: stats.shippedCount,
      icon: Icons.local_shipping_outlined,
      color: AppPalette.secondaryOrange,
      isSelected: activeFilter == OrderStatus.shipped,
      onTap: () => onSelectFilter(OrderStatus.shipped),
    ),
    StatFilterTabItem(
      title: AppStrings.statusDelivered,
      count: stats.deliveredCount,
      icon: Icons.check_circle_outline_rounded,
      color: AppPalette.accentGreen,
      isSelected: activeFilter == OrderStatus.delivered,
      onTap: () => onSelectFilter(OrderStatus.delivered),
    ),
    StatFilterTabItem(
      title: AppStrings.statusCancelled,
      count: stats.cancelledCount,
      icon: Icons.cancel_outlined,
      color: AppPalette.error,
      isSelected: activeFilter == OrderStatus.cancelled,
      onTap: () => onSelectFilter(OrderStatus.cancelled),
    ),
  ];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      spacing: 8.w,
      children: _items.map((item) => StatFilterTab(item: item)).toList(),
    ),
  );
}
