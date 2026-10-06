import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_filter_chip.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_search_filter_chips.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrdersSearchFilterChips Widget Tests', () {
    testWidgets('should render 3 search filter chips with their labels', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: OrdersSearchFilterChips(
            selectedSearchBy: OrderSearchBy.orderId,
            onSelected: (_) {},
          ),
        ),
      );

      // Assert
      expect(find.byType(SearchFilterChip), findsNWidgets(3));
      for (final searchBy in OrderSearchBy.values) {
        expect(find.text(searchBy.label), findsOneWidget);
      }
    });

    testWidgets('should call onSelected when a chip is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      OrderSearchBy? selected;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: OrdersSearchFilterChips(
            selectedSearchBy: OrderSearchBy.orderId,
            onSelected: (by) => selected = by,
          ),
        ),
      );

      // Act
      await tester.scrollUntilVisible(
        find.text(OrderSearchBy.customerName.label),
        150,
        scrollable: find.byType(Scrollable),
      );
      await tester.tap(find.text(OrderSearchBy.customerName.label));
      await tester.pump();

      // Assert
      expect(selected, OrderSearchBy.customerName);
    });
  });
}
