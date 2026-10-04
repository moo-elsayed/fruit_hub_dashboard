import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_action_button.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('ProductActionButton Widget Tests', () {
    testWidgets(
      'should render default constructor icon and trigger onTap when tapped',
      (WidgetTester tester) async {
        // Arrange
        var tapped = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: ProductActionButton(
              icon: Icons.edit_rounded,
              iconColor: AppPalette.primaryGreen,
              onTap: () => tapped = true,
            ),
          ),
        );

        // Assert initial
        expect(find.byIcon(Icons.edit_rounded), findsOneWidget);

        // Act
        await tester.tap(find.byType(ProductActionButton));
        await tester.pump();

        // Assert callback
        expect(tapped, isTrue);
      },
    );

    testWidgets(
      'should render delete named constructor with delete icon and trigger onTap when tapped',
      (WidgetTester tester) async {
        // Arrange
        var deleteTapped = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: ProductActionButton.delete(onTap: () => deleteTapped = true),
          ),
        );

        // Assert initial
        expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

        // Act
        await tester.tap(find.byType(ProductActionButton));
        await tester.pump();

        // Assert callback
        expect(deleteTapped, isTrue);
      },
    );

    testWidgets(
      'should render custom background color, border color, and rectangle shape when specified',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: ProductActionButton(
              icon: Icons.close_rounded,
              isCircle: false,
              borderRadius: 12,
              hasShadow: false,
              backgroundColor: AppPalette.bgLightSecondary,
              borderColor: AppPalette.borderLight,
              onTap: () {},
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.close_rounded), findsOneWidget);
        final decoratedBox = tester.widget<DecoratedBox>(
          find.descendant(
            of: find.byType(ProductActionButton),
            matching: find.byType(DecoratedBox),
          ),
        );
        final decoration = decoratedBox.decoration as BoxDecoration;
        expect(decoration.shape, equals(BoxShape.rectangle));
        expect(decoration.color, equals(AppPalette.bgLightSecondary));
        expect(decoration.boxShadow, isNull);
      },
    );
  });
}
