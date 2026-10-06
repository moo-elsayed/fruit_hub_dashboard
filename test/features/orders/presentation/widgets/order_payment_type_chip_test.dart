import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_payment_type_chip.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderPaymentTypeChip Widget Tests', () {
    testWidgets(
      'should render paypal icon and label when paymentType is paypal',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrderPaymentTypeChip(
              paymentType: PaymentMethodType.paypal,
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.paypal), findsOneWidget);
        expect(find.text(AppStrings.payByPaypal), findsOneWidget);
      },
    );

    testWidgets(
      'should render credit_card icon and label when paymentType is card',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrderPaymentTypeChip(
              paymentType: PaymentMethodType.card,
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.credit_card), findsOneWidget);
        expect(find.text(AppStrings.payByCreditCard), findsOneWidget);
      },
    );

    testWidgets(
      'should render attach_money icon and label when paymentType is cash',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrderPaymentTypeChip(
              paymentType: PaymentMethodType.cash,
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.attach_money), findsOneWidget);
        expect(find.text(AppStrings.cashOnDelivery), findsOneWidget);
      },
    );
  });
}
