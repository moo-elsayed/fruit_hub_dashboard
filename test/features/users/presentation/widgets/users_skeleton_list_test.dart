import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_card_item.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_skeleton_list.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UsersSkeletonList Widget Tests', () {
    testWidgets(
      'should render enabled Skeletonizer with specified number of skeleton items',
      (WidgetTester tester) async {
        // Arrange
        const testItemCount = 4;

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UsersSkeletonList(itemCount: testItemCount),
          ),
        );

        // Assert
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == '_Skeletonizer',
          ),
          findsOneWidget,
        );
        expect(find.byType(UserCardItem), findsNWidgets(testItemCount));
      },
    );

    testWidgets(
      'should apply custom padding when provided',
      (WidgetTester tester) async {
        // Arrange
        const customPadding = EdgeInsets.all(20);

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UsersSkeletonList(
              itemCount: 2,
              padding: customPadding,
            ),
          ),
        );

        // Assert
        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.padding, equals(customPadding));
      },
    );
  });
}
