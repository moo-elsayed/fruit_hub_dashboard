import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_count_badge.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_product_card.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_products_list.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderProductsList Widget Tests', () {
    const List<OrderItemEntity> tProducts = [
      OrderItemEntity(
        name: 'Organic Apples',
        code: 'APL01',
        price: 45.0,
        quantity: 2,
        imagePath: 'https://example.com/apple.png',
      ),
      OrderItemEntity(
        name: 'Fresh Oranges',
        code: 'ORG02',
        price: 30.0,
        quantity: 3,
        imagePath: 'https://example.com/orange.png',
      ),
    ];

    testWidgets(
      'should render header with items count badge and product cards when initially expanded',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrderProductsList(products: tProducts),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.orderedItems), findsOneWidget);
        expect(
          find.byWidgetPredicate((w) => w is CustomCountBadge && w.count == 2),
          findsOneWidget,
        );
        expect(find.byType(OrderProductCard), findsNWidgets(2));
        expect(find.text('Organic Apples'), findsOneWidget);
        expect(find.text('Fresh Oranges'), findsOneWidget);
      },
    );

    testWidgets('should toggle expand/collapse when header is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderProductsList(
            products: tProducts,
            initiallyExpanded: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act: Tap to collapse
      await tester.tap(find.text(AppStrings.orderedItems));
      await tester.pumpAndSettle();

      // SizeTransition sizeFactor will be 0.0
      final sizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );
      expect(sizeTransition.sizeFactor.value, 0.0);

      // Act: Tap again to expand
      await tester.tap(find.text(AppStrings.orderedItems));
      await tester.pumpAndSettle();

      final expandedSizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );
      expect(expandedSizeTransition.sizeFactor.value, 1.0);
    });
  });
}
