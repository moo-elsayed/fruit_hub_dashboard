import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/custom_order_item.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_skeleton_list.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrdersSkeletonList Widget Tests', () {
    testWidgets(
      'should render ListView with Skeletonizer and CustomOrderItem widgets',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersSkeletonList()),
        );

        // Assert
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == '_Skeletonizer',
          ),
          findsOneWidget,
        );
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(CustomOrderItem), findsWidgets);
      },
    );

    testWidgets('should render custom itemCount of skeleton items', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const OrdersSkeletonList(itemCount: 2)),
      );

      // Assert
      expect(find.byType(CustomOrderItem), findsNWidgets(2));
    });
  });
}
