import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/payment_method_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_empty_state_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/payment_methods_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('PaymentMethodsCard Widget Tests', () {
    testWidgets(
      'should render title and AnalyticsEmptyStateCard when totalTransactions is 0',
      (tester) async {
        // Arrange
        const emptyStats = [
          PaymentMethodStatEntity(type: PaymentMethodType.cash, count: 0),
          PaymentMethodStatEntity(type: PaymentMethodType.card, count: 0),
        ];
        const sut = PaymentMethodsCard(paymentMethodStats: emptyStats);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.paymentMethodsBreakdown), findsOneWidget);
        expect(find.text('0 ${AppStrings.orders}'), findsOneWidget);
        expect(find.byType(AnalyticsEmptyStateCard), findsOneWidget);
      },
    );

    testWidgets(
      'should render payment method rows with titles and counts when totalTransactions > 0',
      (tester) async {
        // Arrange
        const stats = [
          PaymentMethodStatEntity(type: PaymentMethodType.cash, count: 20),
          PaymentMethodStatEntity(type: PaymentMethodType.card, count: 10),
          PaymentMethodStatEntity(type: PaymentMethodType.paypal, count: 5),
        ];
        const sut = PaymentMethodsCard(paymentMethodStats: stats);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.paymentMethodsBreakdown), findsOneWidget);
        expect(find.text('35 ${AppStrings.orders}'), findsOneWidget);
        expect(find.byType(AnalyticsEmptyStateCard), findsNothing);
        expect(find.text(PaymentMethodType.cash.title), findsOneWidget);
        expect(find.text(PaymentMethodType.card.title), findsOneWidget);
        expect(find.text(PaymentMethodType.paypal.title), findsOneWidget);
      },
    );
  });
}
