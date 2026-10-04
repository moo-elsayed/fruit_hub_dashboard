import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/app_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_card_item.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_search_results_list.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UsersSearchResultsList Widget Tests', () {
    const tUser1 = AppUserEntity(
      uid: 'user_1',
      name: 'Kareem Ahmed',
      email: 'kareem@example.com',
      phone: '01011112222',
      isVerified: true,
    );

    const tUser2 = AppUserEntity(
      uid: 'user_2',
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01033334444',
      isVerified: false,
    );

    testWidgets('should render UserCardItem for each user in the list', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const UsersSearchResultsList(users: [tUser1, tUser2]),
        ),
      );

      // Assert
      expect(find.byType(UserCardItem), findsNWidgets(2));
      expect(find.text(tUser1.name), findsOneWidget);
      expect(find.text(tUser2.name), findsOneWidget);
    });

    testWidgets(
      'should navigate to userDetailsView with selected user on tap',
      (WidgetTester tester) async {
        // Arrange
        AppUserEntity? passedUser;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UsersSearchResultsList(users: [tUser1]),
            onGenerateRoute: (settings) {
              if (settings.name == Routes.userDetailsView) {
                passedUser = settings.arguments as AppUserEntity?;
                return MaterialPageRoute(
                  builder: (_) => const Scaffold(body: Text('User Details')),
                );
              }
              return null;
            },
          ),
        );

        // Act
        await tester.tap(find.text(tUser1.name));
        await tester.pumpAndSettle();

        // Assert
        expect(passedUser, equals(tUser1));
        expect(find.text('User Details'), findsOneWidget);
      },
    );
  });
}
