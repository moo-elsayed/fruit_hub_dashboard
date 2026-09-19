import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/notification_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/repo/users_repo.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_user_notifications_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepo extends Mock implements UsersRepo {}

void main() {
  late MockUsersRepo mockUsersRepo;
  late GetUserNotificationsUseCase sut;

  const tUserId = 'user_123';
  const tFailure = ServerFailure(error: 'Failed to fetch user notifications');

  final tNotifications = [
    NotificationEntity(
      id: 'notif_1',
      titleAr: 'تحديث الحساب',
      titleEn: 'Account Update',
      bodyAr: 'تم تحديث بياناتك بنجاح',
      bodyEn: 'Your profile has been updated',
      type: NotificationType.general,
      isRead: false,
      createdAt: DateTime(2026, 9, 18, 10, 0),
    ),
    NotificationEntity(
      id: 'notif_2',
      titleAr: 'حالة الطلب',
      titleEn: 'Order Status',
      bodyAr: 'تم شحن طلبك',
      bodyEn: 'Your order was shipped',
      type: NotificationType.order,
      isRead: true,
      orderId: 'ORD_101',
      status: 'shipped',
      createdAt: DateTime(2026, 9, 18, 11, 0),
    ),
  ];

  setUp(() {
    mockUsersRepo = MockUsersRepo();
    sut = GetUserNotificationsUseCase(mockUsersRepo);
  });

  group('GetUserNotificationsUseCase', () {
    test('should return NetworkSuccess with notifications list when repo call is successful', () async {
      // Arrange
      when(() => mockUsersRepo.getUserNotifications(tUserId))
          .thenAnswer((_) async => NetworkSuccess(tNotifications));

      // Act
      final result = await sut(tUserId);

      // Assert
      expect(result, isA<NetworkSuccess<List<NotificationEntity>>>());
      final list = (result as NetworkSuccess<List<NotificationEntity>>).data!;
      expect(list, tNotifications);
      expect(list.length, 2);
      expect(list.first.id, 'notif_1');

      verify(() => mockUsersRepo.getUserNotifications(tUserId)).called(1);
      verifyNoMoreInteractions(mockUsersRepo);
    });

    test(
      'should return NetworkFailure when repo call returns failure',
      () async {
        // Arrange
        when(() => mockUsersRepo.getUserNotifications(tUserId))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(tUserId);

        // Assert
        expect(result, isA<NetworkFailure<List<NotificationEntity>>>());
        final failure =
            (result as NetworkFailure<List<NotificationEntity>>).failure;
        expect(failure.error, tFailure.error);

        verify(() => mockUsersRepo.getUserNotifications(tUserId)).called(1);
        verifyNoMoreInteractions(mockUsersRepo);
      },
    );
  });
}
