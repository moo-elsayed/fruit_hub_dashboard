import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/price_per_kilo.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('PricePerKilo Widget Tests', () {
    testWidgets('should render formatted price, pounds, and kilo texts', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPrice = 25.5;

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const PricePerKilo(price: testPrice)),
      );

      // Assert
      final textFinder = find.descendant(
        of: find.byType(PricePerKilo),
        matching: find.byType(Text),
      );
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      final textSpan = textWidget.textSpan as TextSpan?;
      expect(textSpan, isNotNull);
      final fullText = textSpan!.toPlainText();

      expect(fullText, contains('${testPrice.formattedPrice}'));
      expect(fullText, contains(AppStrings.pounds));
      expect(fullText, contains(AppStrings.kilo));
    });
  });
}
