import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

import 'order_header_badge.dart';

class OrderCardHeader extends StatelessWidget {
  const OrderCardHeader({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
  });

  final int orderId;
  final String date;
  final OrderStatus status;

  static String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return '';
    return rawDate.length > 10 ? rawDate.substring(0, 10) : rawDate;
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      OrderHeaderBadge(
        label: '${AppStrings.orderNumberPrefix}$orderId',
        color: context.colors.primary,
        icon: Icons.tag_rounded,
      ),
      if (date.isNotEmpty)
        OrderHeaderBadge(
          label: _formatDate(date),
          color: context.colors.subText,
          icon: Icons.calendar_today_outlined,
        ),
      OrderHeaderBadge(
        label: status.getName,
        color: status.color,
        showDot: true,
      ),
    ],
  );
}
