import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_details_tab_empty_state.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserDetailsTabEmptyState Widget Tests', () {
    testWidgets('should render icon and message correctly', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: UserDetailsTabEmptyState(
            icon: Icons.shopping_cart_outlined,
            message: AppStrings.emptyCart,
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text(AppStrings.emptyCart), findsOneWidget);
    });
  });
}
