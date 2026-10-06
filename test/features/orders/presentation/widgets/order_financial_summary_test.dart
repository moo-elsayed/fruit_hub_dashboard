import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_price_text.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_financial_summary.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderFinancialSummary Widget Tests', () {
    testWidgets(
      'should render subtotal, delivery cost, and grand total when delivery cost is greater than 0',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrderFinancialSummary(
              subtotal: 300.0,
              shippingCost: 30.0,
              totalPrice: 330.0,
            ),
          ),
        );

        // Assert
        expect(find.text(AppStrings.subtotal), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) => w is CustomPriceText && w.price == 300.0,
          ),
          findsOneWidget,
        );

        expect(find.text(AppStrings.delivery), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) => w is CustomPriceText && w.price == 30.0,
          ),
          findsOneWidget,
        );

        expect(find.text(AppStrings.grandTotal), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) => w is CustomPriceText && w.price == 330.0 && w.isLarge,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('should render freeShipping text when shipping cost is 0', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderFinancialSummary(
            subtotal: 500.0,
            shippingCost: 0.0,
            totalPrice: 500.0,
          ),
        ),
      );

      // Assert
      expect(find.text(AppStrings.freeShipping), findsOneWidget);
      expect(find.text(AppStrings.grandTotal), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => w is CustomPriceText && w.price == 500.0),
        findsNWidgets(2), // subtotal and grandTotal
      );
    });
  });
}
