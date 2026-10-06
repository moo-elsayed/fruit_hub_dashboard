import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/custom_order_item.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_search_results_list.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrdersSearchResultsList Widget Tests', () {
    const tOrders = [
      OrderEntity(
        docId: 'doc_1',
        orderId: 101,
        totalPrice: 200.0,
        status: OrderStatus.pending,
      ),
      OrderEntity(
        docId: 'doc_2',
        orderId: 102,
        totalPrice: 300.0,
        status: OrderStatus.delivered,
      ),
    ];

    testWidgets('should render CustomOrderItem for each order in list', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrdersSearchResultsList(orders: tOrders),
        ),
      );

      // Assert
      expect(find.byType(CustomOrderItem), findsNWidgets(2));
      expect(find.byKey(const ValueKey('doc_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('doc_2')), findsOneWidget);
    });
  });
}
