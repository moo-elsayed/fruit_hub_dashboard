import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/user_avatar_widget.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserAvatarWidget Widget Tests', () {
    testWidgets(
      'should render first letter of name when image is not provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserAvatarWidget(name: 'Mohamed'),
          ),
        );

        // Assert
        expect(find.text('M'), findsOneWidget);
        expect(find.byIcon(Icons.person_rounded), findsNothing);
      },
    );

    testWidgets(
      'should render fallback person icon when neither image nor name are provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UserAvatarWidget()),
        );

        // Assert
        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'should render CachedNetworkImage when http image is provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserAvatarWidget(
              imagePath: 'https://example.com/avatar.jpg',
              name: 'Sarah',
            ),
          ),
        );

        // Assert
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      },
    );
  });
}
