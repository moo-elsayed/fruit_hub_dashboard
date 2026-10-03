import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_search_filter_chips.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UsersSearchFilterChips Widget Tests', () {
    testWidgets(
      'should render all filter chips with correct labels and icons',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UsersSearchFilterChips(
              selectedSearchBy: UserSearchBy.name,
              onSelected: (_) {},
            ),
          ),
        );

        // Assert
        expect(find.text(AppStrings.searchByName), findsOneWidget);
        expect(find.text(AppStrings.searchByEmail), findsOneWidget);
        expect(find.text(AppStrings.searchByPhone), findsOneWidget);

        expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
        expect(find.byIcon(Icons.mail_outline_rounded), findsOneWidget);
        expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'should trigger onSelected callback when a filter chip is tapped',
      (WidgetTester tester) async {
        // Arrange
        UserSearchBy? selected;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UsersSearchFilterChips(
              selectedSearchBy: UserSearchBy.name,
              onSelected: (by) => selected = by,
            ),
          ),
        );

        // Act - Tap Email chip
        await tester.tap(find.text(AppStrings.searchByEmail));
        await tester.pumpAndSettle();

        // Assert
        expect(selected, equals(UserSearchBy.email));

        // Act - Tap Phone chip
        await tester.ensureVisible(find.text(AppStrings.searchByPhone));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.searchByPhone));
        await tester.pumpAndSettle();

        // Assert
        expect(selected, equals(UserSearchBy.phone));
      },
    );
  });
}
