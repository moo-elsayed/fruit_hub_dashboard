import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_badge.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('ProductBadge Widget Tests', () {
    const tIcon = Icons.eco_rounded;
    const tColor = AppPalette.primaryGreen;
    const tTooltip = 'Organic';

    testWidgets(
      'should render badge icon with specified color and without tooltip when tooltip is null',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const ProductBadge(icon: tIcon, color: tColor),
          ),
        );

        // Assert
        expect(find.byIcon(tIcon), findsOneWidget);
        expect(find.byType(Tooltip), findsNothing);
      },
    );

    testWidgets(
      'should render tooltip widget wrapping the badge when tooltip is provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const ProductBadge(
              icon: tIcon,
              color: tColor,
              tooltip: tTooltip,
            ),
          ),
        );

        // Assert
        expect(find.byType(Tooltip), findsOneWidget);
        expect(find.byIcon(tIcon), findsOneWidget);

        final tooltipWidget = tester.widget<Tooltip>(find.byType(Tooltip));
        expect(tooltipWidget.message, equals(tTooltip));
        expect(tooltipWidget.triggerMode, equals(TooltipTriggerMode.tap));
      },
    );
  });
}
