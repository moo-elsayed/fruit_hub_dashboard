import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/app_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/cart_item_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_card_item.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserCardItem Widget Tests', () {
    const tUser = AppUserEntity(
      uid: 'user_1',
      name: 'Ahmed Mohamed',
      email: 'ahmed@example.com',
      phone: '01012345678',
      isVerified: true,
      languageCode: 'ar',
      cartItems: [
        CartItemEntity(productId: 'prod_1', quantity: 2),
        CartItemEntity(productId: 'prod_2', quantity: 1),
      ],
      favoriteIds: ['fav_1', 'fav_2'],
    );

    testWidgets(
      'should render user details, badges, and verified icon correctly',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UserCardItem(user: tUser, onTap: () {}),
          ),
        );

        // Assert
        expect(find.text(tUser.name), findsOneWidget);
        expect(find.text(tUser.email), findsOneWidget);
        expect(find.text(tUser.phone), findsOneWidget);
        expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

        // Badges
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
        expect(find.text('3 ${AppStrings.itemsCount}'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('AR'), findsOneWidget);
      },
    );

    testWidgets('should display email as title when name is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      const emptyNameUser = AppUserEntity(
        uid: 'user_2',
        name: '',
        email: 'no_name@example.com',
      );

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: UserCardItem(user: emptyNameUser, onTap: () {}),
        ),
      );

      // Assert
      expect(find.text(emptyNameUser.email), findsOneWidget);
      expect(find.text(emptyNameUser.name), findsNothing);
    });

    testWidgets(
      'should not display verified icon or optional badges when not applicable',
      (WidgetTester tester) async {
        // Arrange
        const unverifiedUser = AppUserEntity(
          uid: 'user_3',
          name: 'Sarah Ali',
          email: 'sarah@example.com',
          isVerified: false,
          cartItems: [],
          favoriteIds: [],
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UserCardItem(user: unverifiedUser, onTap: () {}),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.verified_rounded), findsNothing);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsNothing);
        expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
        expect(find.byIcon(Icons.language_rounded), findsOneWidget);
      },
    );

    testWidgets('should trigger onTap callback when user card is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool wasTapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: UserCardItem(user: tUser, onTap: () => wasTapped = true),
        ),
      );

      // Act
      await tester.tap(find.byType(UserCardItem));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });
  });
}
