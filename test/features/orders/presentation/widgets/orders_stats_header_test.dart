import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_stats_header.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrdersStatsHeader Widget Tests', () {
    const tStats = OrdersStatsEntity(
      totalCount: 50,
      pendingCount: 15,
      processingCount: 10,
      shippedCount: 8,
      deliveredCount: 12,
      cancelledCount: 5,
    );

    testWidgets(
      'should render all 6 stat filter tabs with titles, counts, and icons',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: OrdersStatsHeader(
              stats: tStats,
              activeFilter: null,
              onSelectFilter: (_) {},
            ),
          ),
        );

        // Assert
        expect(find.text(AppStrings.all), findsOneWidget);
        expect(find.text('50'), findsOneWidget);
        expect(find.byIcon(Icons.receipt_long_rounded), findsOneWidget);

        expect(find.text(AppStrings.statusPending), findsOneWidget);
        expect(find.text('15'), findsOneWidget);
        expect(find.byIcon(Icons.pending_actions_rounded), findsOneWidget);

        expect(find.text(AppStrings.statusProcessing), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        expect(find.byIcon(Icons.sync_rounded), findsOneWidget);

        expect(find.text(AppStrings.statusShipped), findsOneWidget);
        expect(find.text('8'), findsOneWidget);
        expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);

        expect(find.text(AppStrings.statusDelivered), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);

        expect(find.text(AppStrings.statusCancelled), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
      },
    );

    testWidgets('should call onSelectFilter with null when all tab is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      OrderStatus? selectedFilter = OrderStatus.pending;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: OrdersStatsHeader(
            stats: tStats,
            activeFilter: OrderStatus.pending,
            onSelectFilter: (filter) => selectedFilter = filter,
          ),
        ),
      );

      // Act
      await tester.tap(find.text(AppStrings.all));
      await tester.pump();

      // Assert
      expect(selectedFilter, isNull);
    });

    testWidgets(
      'should call onSelectFilter with corresponding status when tapped',
      (WidgetTester tester) async {
        // Arrange
        OrderStatus? selectedFilter;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: OrdersStatsHeader(
              stats: tStats,
              activeFilter: null,
              onSelectFilter: (filter) => selectedFilter = filter,
            ),
          ),
        );

        // Act & Assert Pending
        await tester.tap(find.text(AppStrings.statusPending));
        await tester.pump();
        expect(selectedFilter, OrderStatus.pending);

        // Act & Assert Delivered
        await tester.scrollUntilVisible(
          find.text(AppStrings.statusDelivered),
          200,
          scrollable: find.byType(Scrollable),
        );
        await tester.tap(find.text(AppStrings.statusDelivered));
        await tester.pump();
        expect(selectedFilter, OrderStatus.delivered);
      },
    );
  });
}
