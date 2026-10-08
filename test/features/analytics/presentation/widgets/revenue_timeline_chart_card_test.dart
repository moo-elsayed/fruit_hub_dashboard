import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/revenue_data_point_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/revenue_line_chart.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/revenue_timeline_chart_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('RevenueTimelineChartCard Widget Tests', () {
    testWidgets(
      'should render header, total range revenue, days count badge, and RevenueLineChart',
      (tester) async {
        // Arrange
        final dataPoints = [
          RevenueDataPointEntity(
            date: DateTime(2026, 9, 1),
            revenue: 500.0,
            ordersCount: 2,
          ),
          RevenueDataPointEntity(
            date: DateTime(2026, 9, 2),
            revenue: 1500.0,
            ordersCount: 5,
          ),
        ];
        final sut = RevenueTimelineChartCard(dataPoints: dataPoints);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.revenueTimeline), findsOneWidget);
        expect(find.text('2000 ${AppStrings.pounds}'), findsOneWidget);
        expect(find.text('2 ${AppStrings.days}'), findsOneWidget);
        expect(find.byType(RevenueLineChart), findsOneWidget);
      },
    );
  });
}
