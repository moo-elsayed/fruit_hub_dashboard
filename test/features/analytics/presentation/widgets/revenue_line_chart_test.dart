import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/revenue_data_point_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/revenue_line_chart.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('RevenueLineChart Widget Tests', () {
    testWidgets('should render LineChart with data points correctly', (
      tester,
    ) async {
      // Arrange
      final dataPoints = [
        RevenueDataPointEntity(
          date: DateTime(2026, 9, 1),
          revenue: 100.0,
          ordersCount: 1,
        ),
        RevenueDataPointEntity(
          date: DateTime(2026, 9, 2),
          revenue: 300.0,
          ordersCount: 2,
        ),
        RevenueDataPointEntity(
          date: DateTime(2026, 9, 3),
          revenue: 250.0,
          ordersCount: 2,
        ),
      ];
      final sut = SizedBox(
        height: 220,
        child: RevenueLineChart(dataPoints: dataPoints),
      );

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets(
      'should render LineChart without throwing when dataPoints is empty',
      (tester) async {
        // Arrange
        const sut = SizedBox(
          height: 220,
          child: RevenueLineChart(dataPoints: []),
        );

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(LineChart), findsOneWidget);
      },
    );
  });
}
