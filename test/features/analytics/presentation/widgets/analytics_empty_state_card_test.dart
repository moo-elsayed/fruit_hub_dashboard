import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_empty_state_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('AnalyticsEmptyStateCard Widget Tests', () {
    testWidgets(
      'should render default noOrdersYet message when message is not provided',
      (tester) async {
        // Arrange
        const sut = AnalyticsEmptyStateCard();

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.noOrdersYet), findsOneWidget);
      },
    );

    testWidgets('should render custom message when message is provided', (
      tester,
    ) async {
      // Arrange
      const customMsg = 'لا توجد بيانات متاحة حالياً';
      const sut = AnalyticsEmptyStateCard(message: customMsg);

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(customMsg), findsOneWidget);
      expect(find.text(AppStrings.noOrdersYet), findsNothing);
    });
  });
}
