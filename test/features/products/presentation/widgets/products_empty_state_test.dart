import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/products_empty_state.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('ProductsEmptyState Widget Tests', () {
    testWidgets(
      'should render shopping bag icon, no products title, and add first product subtitle',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const ProductsEmptyState()),
        );

        // Assert
        expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
        expect(find.text(AppStrings.noProductsYet), findsOneWidget);
        expect(find.text(AppStrings.addFirstProduct), findsOneWidget);
      },
    );
  });
}
