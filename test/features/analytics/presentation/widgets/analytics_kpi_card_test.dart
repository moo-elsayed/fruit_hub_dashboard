import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_kpi_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('AnalyticsKpiCard Widget Tests', () {
    testWidgets('should render icon, value, and plain title correctly', (
      tester,
    ) async {
      // Arrange
      const sut = AnalyticsKpiCard(
        title: 'إجمالي الإيرادات',
        value: '15000 ج.م',
        icon: Icons.monetization_on_rounded,
        accentColor: AppPalette.accentGreen,
      );

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.monetization_on_rounded), findsOneWidget);
      expect(find.text('15000 ج.م'), findsOneWidget);
      expect(find.text('إجمالي الإيرادات'), findsOneWidget);
    });

    testWidgets(
      'should render titleSpan when provided instead of plain title',
      (tester) async {
        // Arrange
        const sut = AnalyticsKpiCard(
          title: 'إجمالي المستخدمين',
          value: '120',
          icon: Icons.people_alt_rounded,
          accentColor: AppPalette.kpiUsers,
          titleSpan: TextSpan(
            children: [
              TextSpan(text: 'المستخدمين '),
              TextSpan(text: '(80 نشط)'),
            ],
          ),
        );

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.people_alt_rounded), findsOneWidget);
        expect(find.text('120'), findsOneWidget);
        expect(
          find.text('المستخدمين (80 نشط)', findRichText: true),
          findsOneWidget,
        );
      },
    );
  });
}
