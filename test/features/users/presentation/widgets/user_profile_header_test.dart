import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/user_avatar_widget.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/app_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_profile_header.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserProfileHeader Widget Tests', () {
    const tUserVerified = AppUserEntity(
      uid: 'user_1',
      name: 'Ahmed Ali',
      email: 'ahmed@example.com',
      phone: '01011112222',
      isVerified: true,
      image: 'https://example.com/avatar.png',
    );

    const tUserUnverified = AppUserEntity(
      uid: 'user_2',
      name: 'Sara Omar',
      email: 'sara@example.com',
      phone: '01033334444',
      isVerified: false,
    );

    testWidgets(
      'should render user avatar, name, email, phone, and verified icon when verified',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UserProfileHeader(
              user: tUserVerified,
              onSendNotification: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(UserAvatarWidget), findsOneWidget);
        expect(find.text(tUserVerified.name), findsOneWidget);
        expect(find.text(tUserVerified.email), findsOneWidget);
        expect(find.text(tUserVerified.phone), findsOneWidget);
        expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
        expect(find.byIcon(Icons.notifications_active_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'should not render verified icon when user is not verified',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UserProfileHeader(
              user: tUserUnverified,
              onSendNotification: () {},
            ),
          ),
        );

        // Assert
        expect(find.text(tUserUnverified.name), findsOneWidget);
        expect(find.byIcon(Icons.verified_rounded), findsNothing);
      },
    );

    testWidgets(
      'should call onSendNotification when notification button is tapped',
      (WidgetTester tester) async {
        // Arrange
        var tapped = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UserProfileHeader(
              user: tUserVerified,
              onSendNotification: () => tapped = true,
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.notifications_active_outlined));
        await tester.pumpAndSettle();

        // Assert
        expect(tapped, isTrue);
      },
    );
  });
}
