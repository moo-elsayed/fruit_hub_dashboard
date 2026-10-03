import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/cart_item_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_cart_items_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_details_tab_empty_state.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserCartItemsList Widget Tests', () {
    const tCartItem1 = CartItemEntity(productId: 'prod_123', quantity: 2);
    const tCartItem2 = CartItemEntity(productId: 'prod_456', quantity: 1);

    testWidgets(
      'should render UserDetailsTabEmptyState when cartItems is empty',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserCartItemsList(cartItems: []),
          ),
        );

        // Assert
        expect(find.byType(UserDetailsTabEmptyState), findsOneWidget);
        expect(find.text(AppStrings.emptyCart), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'should render cart item cards with product ID and quantity when cartItems is not empty',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserCartItemsList(
              cartItems: [tCartItem1, tCartItem2],
            ),
          ),
        );

        // Assert
        expect(find.byType(UserDetailsTabEmptyState), findsNothing);
        expect(
          find.text('${AppStrings.productCode}: ${tCartItem1.productId}'),
          findsOneWidget,
        );
        expect(find.text('x${tCartItem1.quantity}'), findsOneWidget);
        expect(
          find.text('${AppStrings.productCode}: ${tCartItem2.productId}'),
          findsOneWidget,
        );
        expect(find.text('x${tCartItem2.quantity}'), findsOneWidget);
      },
    );
  });
}
