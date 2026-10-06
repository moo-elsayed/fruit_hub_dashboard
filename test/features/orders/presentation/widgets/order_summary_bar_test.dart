import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_price_text.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_payment_type_chip.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_summary_bar.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderSummaryBar Widget Tests', () {
    testWidgets(
      'should render totalPrice, payment chip, and viewDetails when isExpanded is false',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: OrderSummaryBar(
              totalPrice: 420.0,
              paymentType: PaymentMethodType.card,
              isExpanded: false,
              onToggle: () {},
            ),
          ),
        );

        // Assert
        expect(
          find.byWidgetPredicate(
            (w) => w is CustomPriceText && w.price == 420.0 && w.isLarge,
          ),
          findsOneWidget,
        );
        expect(find.byType(OrderPaymentTypeChip), findsOneWidget);
        expect(find.text(AppStrings.viewDetails), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'should render hideDetails text and trigger onToggle when tapped',
      (WidgetTester tester) async {
        // Arrange
        bool toggled = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: OrderSummaryBar(
              totalPrice: 420.0,
              paymentType: PaymentMethodType.cash,
              isExpanded: true,
              onToggle: () => toggled = true,
            ),
          ),
        );

        // Assert
        expect(find.text(AppStrings.hideDetails), findsOneWidget);

        // Act
        await tester.tap(find.text(AppStrings.hideDetails));
        await tester.pump();

        // Assert
        expect(toggled, isTrue);
      },
    );
  });
}
