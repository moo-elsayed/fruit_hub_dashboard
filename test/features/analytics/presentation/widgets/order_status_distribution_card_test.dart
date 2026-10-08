import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/order_status_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_empty_state_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/order_status_distribution_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderStatusDistributionCard Widget Tests', () {
    testWidgets(
      'should render title and AnalyticsEmptyStateCard when total order count is 0',
      (tester) async {
        // Arrange
        const emptyStats = [
          OrderStatusStatEntity(status: OrderStatus.pending, count: 0),
          OrderStatusStatEntity(status: OrderStatus.delivered, count: 0),
        ];
        const sut = OrderStatusDistributionCard(statusStats: emptyStats);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.orderStatusDistribution), findsOneWidget);
        expect(find.text('0 ${AppStrings.orders}'), findsOneWidget);
        expect(find.byType(AnalyticsEmptyStateCard), findsOneWidget);
        expect(find.byType(PieChart), findsNothing);
      },
    );

    testWidgets(
      'should render PieChart and status chips when total order count is greater than 0',
      (tester) async {
        // Arrange
        const stats = [
          OrderStatusStatEntity(status: OrderStatus.delivered, count: 15),
          OrderStatusStatEntity(status: OrderStatus.pending, count: 5),
        ];
        const sut = OrderStatusDistributionCard(statusStats: stats);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.orderStatusDistribution), findsOneWidget);
        expect(find.text('20 ${AppStrings.orders}'), findsOneWidget);
        expect(find.byType(PieChart), findsOneWidget);
        expect(find.byType(AnalyticsEmptyStateCard), findsNothing);
        expect(
          find.text('${OrderStatus.delivered.getName} (15)'),
          findsOneWidget,
        );
        expect(find.text('${OrderStatus.pending.getName} (5)'), findsOneWidget);
      },
    );
  });
}
