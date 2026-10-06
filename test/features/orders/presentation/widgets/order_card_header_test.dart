import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_card_header.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_header_badge.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderCardHeader Widget Tests', () {
    const tOrderId = 9021;
    const tDate = '2026-10-06T12:00:00Z';
    const tStatus = OrderStatus.pending;

    testWidgets('should render orderId, date, status badge, and receipt icon', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderCardHeader(
            orderId: tOrderId,
            date: tDate,
            status: tStatus,
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.receipt_long_rounded), findsOneWidget);
      expect(find.text('${AppStrings.orderNumber} #$tOrderId'), findsOneWidget);
      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);
      expect(find.text(tDate.toFormattedDate()), findsOneWidget);
      expect(find.text(tStatus.getName), findsOneWidget);
      expect(find.byType(OrderHeaderBadge), findsOneWidget);
    });

    testWidgets(
      'should show arrow icon and trigger onStatusTap when provided',
      (WidgetTester tester) async {
        // Arrange
        bool wasTapped = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: OrderCardHeader(
              orderId: tOrderId,
              date: tDate,
              status: tStatus,
              onStatusTap: () => wasTapped = true,
            ),
          ),
        );

        // Assert arrow icon
        expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

        // Act
        await tester.tap(find.byType(OrderHeaderBadge));
        await tester.pump();

        // Assert
        expect(wasTapped, isTrue);
      },
    );

    testWidgets('should not render date row when date string is empty', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderCardHeader(
            orderId: tOrderId,
            date: '',
            status: tStatus,
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.access_time_rounded), findsNothing);
    });
  });
}
