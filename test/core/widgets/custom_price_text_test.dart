import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_price_text.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomPriceText Widget Tests', () {
    testWidgets('should render price and pounds with default styling', (
      WidgetTester tester,
    ) async {
      // Arrange
      const price = 120.0;

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const CustomPriceText(price: price)),
      );

      // Assert
      final textFinder = find.descendant(
        of: find.byType(CustomPriceText),
        matching: find.byType(Text),
      );
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      final rootSpan = textWidget.textSpan as TextSpan;
      final fullText = rootSpan.toPlainText();
      expect(fullText, contains('${price.formattedPrice}'));
      expect(fullText, contains(AppStrings.pounds));
    });

    testWidgets('should apply large styles when isLarge is true', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const CustomPriceText(price: 450, isLarge: true),
        ),
      );

      // Assert
      final textFinder = find.descendant(
        of: find.byType(CustomPriceText),
        matching: find.byType(Text),
      );
      final textWidget = tester.widget<Text>(textFinder);
      final rootSpan = textWidget.textSpan as TextSpan;
      final priceSpan = rootSpan.children![0] as TextSpan;
      expect(priceSpan.style?.fontSize, equals(18.sp));
    });

    testWidgets('should apply custom styles and color when provided', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const CustomPriceText(
            price: 75,
            color: Colors.red,
            priceStyle: TextStyle(fontSize: 22, color: Colors.red),
            currencyStyle: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );

      // Assert
      final textFinder = find.descendant(
        of: find.byType(CustomPriceText),
        matching: find.byType(Text),
      );
      final textWidget = tester.widget<Text>(textFinder);
      final rootSpan = textWidget.textSpan as TextSpan;
      final priceSpan = rootSpan.children![0] as TextSpan;
      final currencySpan = rootSpan.children![1] as TextSpan;

      expect(priceSpan.style?.fontSize, equals(22));
      expect(currencySpan.style?.fontSize, equals(16));
    });
  });
}
