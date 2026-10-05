import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_filter_chip.dart';

class OrdersSearchFilterChips extends StatelessWidget {
  const OrdersSearchFilterChips({
    super.key,
    required this.selectedSearchBy,
    required this.onSelected,
  });

  final OrderSearchBy selectedSearchBy;
  final ValueChanged<OrderSearchBy> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      spacing: 8.w,
      children: OrderSearchBy.values.map((searchBy) {
        final isSelected = selectedSearchBy == searchBy;
        return SearchFilterChip(
          label: searchBy.label,
          icon: switch (searchBy) {
            OrderSearchBy.orderId => Icons.tag_rounded,
            OrderSearchBy.customerName => Icons.person_outline_rounded,
            OrderSearchBy.phone => Icons.phone_outlined,
          },
          isSelected: isSelected,
          onTap: () => onSelected(searchBy),
        );
      }).toList(),
    ),
  );
}
