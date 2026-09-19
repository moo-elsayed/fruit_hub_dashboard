import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/notification_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/send_notification_input_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_user_notifications_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/send_user_notification_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/user_notifications_cubit/user_notifications_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserNotificationsUseCase extends Mock
    implements GetUserNotificationsUseCase {}

class MockSendUserNotificationUseCase extends Mock
    implements SendUserNotificationUseCase {}

class FakeSendNotificationInputEntity extends Fake
    implements SendNotificationInputEntity {}

void main() {
  late MockGetUserNotificationsUseCase mockGetUserNotificationsUseCase;
  late MockSendUserNotificationUseCase mockSendUserNotificationUseCase;
  late UserNotificationsCubit sut;

  const tUserId = 'user_123';
  const tErrorMessage = 'An error occurred';
  const tFailure = ServerFailure(error: tErrorMessage);

  final tNotification1 = NotificationEntity(
    id: 'notif_1',
    titleAr: 'تحديث الحساب',
    titleEn: 'Account Update',
    bodyAr: 'تم تحديث بياناتك',
    bodyEn: 'Profile updated',
    type: NotificationType.general,
    isRead: false,
    createdAt: DateTime(2026, 9, 18, 10, 0),
  );

  final tNotification2 = NotificationEntity(
    id: 'notif_2',
    titleAr: 'تحديث الطلب',
    titleEn: 'Order Update',
    bodyAr: 'تم شحن طلبك',
    bodyEn: 'Your order was shipped',
    type: NotificationType.order,
    isRead: true,
    orderId: 'ORD_1',
    status: 'shipped',
    createdAt: DateTime(2026, 9, 18, 11, 0),
  );

  final tNewNotification = NotificationEntity(
    id: 'notif_new',
    titleAr: 'إشعار جديد',
    titleEn: 'New Notification',
    bodyAr: 'محتوى الإشعار الجديد',
    bodyEn: 'New notification body',
    type: NotificationType.general,
    isRead: false,
    createdAt: DateTime(2026, 9, 18, 12, 0),
  );

  const tSendNotificationInput = SendNotificationInputEntity(
    userId: tUserId,
    titleAr: 'إشعار جديد',
    titleEn: 'New Notification',
    bodyAr: 'محتوى الإشعار الجديد',
    bodyEn: 'New notification body',
    type: NotificationType.general,
  );

  setUpAll(() {
    registerFallbackValue(FakeSendNotificationInputEntity());
  });

  setUp(() {
    mockGetUserNotificationsUseCase = MockGetUserNotificationsUseCase();
    mockSendUserNotificationUseCase = MockSendUserNotificationUseCase();
    sut = UserNotificationsCubit(
      mockGetUserNotificationsUseCase,
      mockSendUserNotificationUseCase,
    );
  });

  tearDown(() => sut.close());

  group('UserNotificationsCubit', () {
    test('initial state should be UserNotificationsInitial', () {
      expect(sut.state, isA<UserNotificationsInitial>());
    });

    group('getUserNotifications', () {
      blocTest<UserNotificationsCubit, UserNotificationsState>(
        'should emit [UserNotificationsLoading, UserNotificationsSuccess] when getUserNotifications succeeds',
        setUp: () {
          when(
            () => mockGetUserNotificationsUseCase.call(tUserId),
          ).thenAnswer((_) async => NetworkSuccess([tNotification1, tNotification2]));
        },
        build: () => sut,
        act: (cubit) => cubit.getUserNotifications(tUserId),
        expect: () => [
          isA<UserNotificationsLoading>(),
          isA<UserNotificationsSuccess>().having(
            (s) => s.notifications,
            'notifications',
            [tNotification1, tNotification2],
          ),
        ],
        verify: (_) {
          verify(() => mockGetUserNotificationsUseCase.call(tUserId)).called(1);
          verifyNoMoreInteractions(mockGetUserNotificationsUseCase);
        },
      );

      blocTest<UserNotificationsCubit, UserNotificationsState>(
        'should emit [UserNotificationsLoading, UserNotificationsSuccess] with empty list when NetworkSuccess data is null',
        setUp: () {
          when(
            () => mockGetUserNotificationsUseCase.call(tUserId),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) => cubit.getUserNotifications(tUserId),
        expect: () => [
          isA<UserNotificationsLoading>(),
          isA<UserNotificationsSuccess>().having(
            (s) => s.notifications,
            'notifications',
            isEmpty,
          ),
        ],
        verify: (_) {
          verify(() => mockGetUserNotificationsUseCase.call(tUserId)).called(1);
          verifyNoMoreInteractions(mockGetUserNotificationsUseCase);
        },
      );

      blocTest<UserNotificationsCubit, UserNotificationsState>(
        'should emit [UserNotificationsLoading, UserNotificationsFailure] when getUserNotifications fails',
        setUp: () {
          when(
            () => mockGetUserNotificationsUseCase.call(tUserId),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.getUserNotifications(tUserId),
        expect: () => [
          isA<UserNotificationsLoading>(),
          isA<UserNotificationsFailure>().having(
            (s) => s.message,
            'message',
            tErrorMessage,
          ),
        ],
        verify: (_) {
          verify(() => mockGetUserNotificationsUseCase.call(tUserId)).called(1);
          verifyNoMoreInteractions(mockGetUserNotificationsUseCase);
        },
      );
    });

    group('sendNotification', () {
      blocTest<UserNotificationsCubit, UserNotificationsState>(
        'should emit [SendNotificationLoading, SendNotificationSuccess, UserNotificationsSuccess] with new notification prepended when sendNotification succeeds',
        setUp: () {
          when(
            () => mockSendUserNotificationUseCase.call(any()),
          ).thenAnswer((_) async => NetworkSuccess(tNewNotification));
        },
        build: () => sut,
        act: (cubit) => cubit.sendNotification(tSendNotificationInput),
        expect: () => [
          isA<SendNotificationLoading>(),
          isA<SendNotificationSuccess>(),
          isA<UserNotificationsSuccess>().having(
            (s) => s.notifications,
            'notifications',
            [tNewNotification],
          ),
        ],
        verify: (_) {
          verify(
            () => mockSendUserNotificationUseCase.call(tSendNotificationInput),
          ).called(1);
          verifyNoMoreInteractions(mockSendUserNotificationUseCase);
        },
      );

      blocTest<UserNotificationsCubit, UserNotificationsState>(
        'should insert newly created notification at index 0 when notifications already exist',
        setUp: () {
          when(
            () => mockGetUserNotificationsUseCase.call(tUserId),
          ).thenAnswer((_) async => NetworkSuccess([tNotification1]));

          when(
            () => mockSendUserNotificationUseCase.call(any()),
          ).thenAnswer((_) async => NetworkSuccess(tNewNotification));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getUserNotifications(tUserId);
          await cubit.sendNotification(tSendNotificationInput);
        },
        expect: () => [
          isA<UserNotificationsLoading>(),
          isA<UserNotificationsSuccess>().having(
            (s) => s.notifications,
            'notifications',
            [tNotification1],
          ),
          isA<SendNotificationLoading>(),
          isA<SendNotificationSuccess>(),
          isA<UserNotificationsSuccess>().having(
            (s) => s.notifications,
            'notifications',
            [tNewNotification, tNotification1],
          ),
        ],
        verify: (_) {
          verify(() => mockGetUserNotificationsUseCase.call(tUserId)).called(1);
          verify(
            () => mockSendUserNotificationUseCase.call(tSendNotificationInput),
          ).called(1);
        },
      );

      blocTest<UserNotificationsCubit, UserNotificationsState>(
        'should emit [SendNotificationLoading, SendNotificationSuccess, UserNotificationsSuccess] without modifying list when returned notification is null',
        setUp: () {
          when(
            () => mockSendUserNotificationUseCase.call(any()),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) => cubit.sendNotification(tSendNotificationInput),
        expect: () => [
          isA<SendNotificationLoading>(),
          isA<SendNotificationSuccess>(),
          isA<UserNotificationsSuccess>().having(
            (s) => s.notifications,
            'notifications',
            isEmpty,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSendUserNotificationUseCase.call(tSendNotificationInput),
          ).called(1);
          verifyNoMoreInteractions(mockSendUserNotificationUseCase);
        },
      );

      blocTest<UserNotificationsCubit, UserNotificationsState>(
        'should emit [SendNotificationLoading, SendNotificationFailure] when sendNotification fails',
        setUp: () {
          when(
            () => mockSendUserNotificationUseCase.call(any()),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.sendNotification(tSendNotificationInput),
        expect: () => [
          isA<SendNotificationLoading>(),
          isA<SendNotificationFailure>().having(
            (s) => s.message,
            'message',
            tErrorMessage,
          ),
        ],
        verify: (_) {
          verify(
            () => mockSendUserNotificationUseCase.call(tSendNotificationInput),
          ).called(1);
          verifyNoMoreInteractions(mockSendUserNotificationUseCase);
        },
      );
    });
  });
}
