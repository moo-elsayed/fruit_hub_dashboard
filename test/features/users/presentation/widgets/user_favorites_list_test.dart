import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_details_tab_empty_state.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_favorites_list.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserFavoritesList Widget Tests', () {
    testWidgets(
      'should render UserDetailsTabEmptyState when favoriteIds is empty',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserFavoritesList(favoriteIds: []),
          ),
        );

        // Assert
        expect(find.byType(UserDetailsTabEmptyState), findsOneWidget);
        expect(find.text(AppStrings.emptyFavorites), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'should render favorite cards with product code when favoriteIds is not empty',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserFavoritesList(favoriteIds: ['fav_111', 'fav_222']),
          ),
        );

        // Assert
        expect(find.byType(UserDetailsTabEmptyState), findsNothing);
        expect(find.text('${AppStrings.productCode}: fav_111'), findsOneWidget);
        expect(find.text('${AppStrings.productCode}: fav_222'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(2));
      },
    );
  });
}
