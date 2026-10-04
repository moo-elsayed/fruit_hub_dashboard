import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/app_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/cart_item_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/user_notifications_cubit/user_notifications_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/views/user_details_view.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/send_notification_bottom_sheet.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_cart_items_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_details_tab_bar.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_favorites_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_notifications_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_profile_header.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockUserNotificationsCubit extends MockCubit<UserNotificationsState>
    implements UserNotificationsCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUserNotificationsCubit mockUserNotificationsCubit;
  late StreamController<UserNotificationsState> stateController;

  const tUser = AppUserEntity(
    uid: 'user_123',
    name: 'Mahmoud Ahmed',
    email: 'mahmoud@example.com',
    phone: '01012345678',
    isVerified: true,
    cartItems: [
      CartItemEntity(productId: 'prod_1', quantity: 2),
      CartItemEntity(productId: 'prod_2', quantity: 1),
    ],
    favoriteIds: ['fav_1', 'fav_2', 'fav_3'],
  );

  setUp(() {
    mockUserNotificationsCubit = MockUserNotificationsCubit();
    stateController = StreamController<UserNotificationsState>.broadcast();

    when(() => mockUserNotificationsCubit.state)
        .thenReturn(UserNotificationsInitial());
    when(() => mockUserNotificationsCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockUserNotificationsCubit.getUserNotifications(any()))
        .thenAnswer((_) async {});

    if (getIt.isRegistered<UserNotificationsCubit>()) {
      getIt.unregister<UserNotificationsCubit>();
    }
    getIt.registerFactory<UserNotificationsCubit>(
      () => mockUserNotificationsCubit,
    );
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<UserNotificationsCubit>()) {
      getIt.unregister<UserNotificationsCubit>();
    }
  });

  group('UserDetailsView Widget Tests', () {
    testWidgets(
      'should render CustomAppBar, UserProfileHeader, and UserDetailsTabBar on init',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UserDetailsView(user: tUser)),
        );
        await tester.pump();

        // Assert
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(AppStrings.userDetails), findsOneWidget);
        expect(find.byType(UserProfileHeader), findsOneWidget);
        expect(find.byType(UserDetailsTabBar), findsOneWidget);

        verify(() => mockUserNotificationsCubit.getUserNotifications(tUser.uid))
            .called(1);
      },
    );

    testWidgets(
      'should render UserCartItemsList, UserFavoritesList, and UserNotificationsList when switching tabs',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UserDetailsView(user: tUser)),
        );
        await tester.pump();

        // Assert Tab 0 (Cart)
        expect(find.byType(UserCartItemsList), findsOneWidget);

        // Act: Switch to Tab 1 (Favorites)
        await tester.tap(
          find.text('${AppStrings.favorites} (${tUser.favoriteIds.length})'),
        );
        await tester.pumpAndSettle();

        // Assert Tab 1 (Favorites)
        expect(find.byType(UserFavoritesList), findsOneWidget);

        // Act: Switch to Tab 2 (Notifications)
        await tester.tap(find.text(AppStrings.notifications));
        await tester.pumpAndSettle();

        // Assert Tab 2 (Notifications)
        expect(find.byType(UserNotificationsList), findsOneWidget);
      },
    );

    testWidgets('should pop view when back arrow is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UserDetailsView(user: tUser),
                ),
              ),
              child: const Text('Open User Details'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open details
      await tester.tap(find.text('Open User Details'));
      await tester.pumpAndSettle();
      expect(find.byType(UserDetailsView), findsOneWidget);

      // Act: tap back arrow
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(UserDetailsView), findsNothing);
      expect(find.text('Open User Details'), findsOneWidget);
    });

    testWidgets(
      'should open SendNotificationBottomSheet when send notification icon is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(child: const UserDetailsView(user: tUser)),
        );
        await tester.pump();

        // Act: Tap notifications icon in profile header
        await tester.tap(find.byIcon(Icons.notifications_active_outlined));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SendNotificationBottomSheet), findsOneWidget);
      },
    );
  });
}
