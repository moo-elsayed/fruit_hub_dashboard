import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/notification_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/user_notifications_cubit/user_notifications_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_details_tab_empty_state.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_notification_item.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_notifications_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_notifications_skeleton_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_status_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockUserNotificationsCubit extends MockCubit<UserNotificationsState>
    implements UserNotificationsCubit {}

void main() {
  late MockUserNotificationsCubit mockUserNotificationsCubit;
  late StreamController<UserNotificationsState> stateController;

  const tNotification = NotificationEntity(
    id: 'notif_1',
    titleAr: 'تنبيه',
    titleEn: 'Alert',
    bodyAr: 'محتوى التنبيه',
    bodyEn: 'Alert body',
    type: NotificationType.general,
    isRead: false,
  );

  setUp(() {
    mockUserNotificationsCubit = MockUserNotificationsCubit();
    stateController = StreamController<UserNotificationsState>.broadcast();

    when(() => mockUserNotificationsCubit.state)
        .thenReturn(UserNotificationsInitial());
    when(() => mockUserNotificationsCubit.stream)
        .thenAnswer((_) => stateController.stream);
  });

  tearDown(() {
    stateController.close();
  });

  group('UserNotificationsList Widget Tests', () {
    testWidgets(
      'should render UserNotificationsSkeletonList when state is UserNotificationsLoading',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUserNotificationsCubit.state)
            .thenReturn(UserNotificationsLoading());

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<UserNotificationsCubit>.value(
              value: mockUserNotificationsCubit,
              child: const UserNotificationsList(),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserNotificationsSkeletonList), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersStatusView with error message when state is UserNotificationsFailure',
      (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Failed to load notifications';
        when(() => mockUserNotificationsCubit.state)
            .thenReturn(const UserNotificationsFailure(errorMessage));

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<UserNotificationsCubit>.value(
              value: mockUserNotificationsCubit,
              child: const UserNotificationsList(),
            ),
          ),
        );

        // Assert
        expect(find.byType(UsersStatusView), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      },
    );

    testWidgets(
      'should render UserDetailsTabEmptyState when notifications list is empty',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUserNotificationsCubit.state)
            .thenReturn(const UserNotificationsSuccess([]));

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<UserNotificationsCubit>.value(
              value: mockUserNotificationsCubit,
              child: const UserNotificationsList(),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserDetailsTabEmptyState), findsOneWidget);
        expect(find.text(AppStrings.emptyNotifications), findsOneWidget);
      },
    );

    testWidgets(
      'should render UserNotificationItem list when state is UserNotificationsSuccess with items',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUserNotificationsCubit.state)
            .thenReturn(const UserNotificationsSuccess([tNotification]));

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<UserNotificationsCubit>.value(
              value: mockUserNotificationsCubit,
              child: const UserNotificationsList(),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserNotificationItem), findsOneWidget);
      },
    );
  });
}
