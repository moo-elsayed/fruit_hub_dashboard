import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/notification_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/send_notification_input_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/repo/users_repo.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/send_user_notification_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepo extends Mock implements UsersRepo {}

class FakeSendNotificationInputEntity extends Fake
    implements SendNotificationInputEntity {}

void main() {
  late MockUsersRepo mockUsersRepo;
  late SendUserNotificationUseCase sut;

  const tInput = SendNotificationInputEntity(
    userId: 'user_100',
    titleAr: 'إشعار جديد',
    titleEn: 'New Notification',
    bodyAr: 'محتوى الإشعار للمستخدم',
    bodyEn: 'Notification body for user',
    type: NotificationType.general,
  );

  final tNotification = NotificationEntity(
    id: 'notif_created_123',
    titleAr: 'إشعار جديد',
    titleEn: 'New Notification',
    bodyAr: 'محتوى الإشعار للمستخدم',
    bodyEn: 'Notification body for user',
    type: NotificationType.general,
    isRead: false,
    createdAt: DateTime(2026, 9, 18, 15, 0),
  );

  const tFailure = ServerFailure(error: 'Failed to send notification');

  setUpAll(() {
    registerFallbackValue(FakeSendNotificationInputEntity());
  });

  setUp(() {
    mockUsersRepo = MockUsersRepo();
    sut = SendUserNotificationUseCase(mockUsersRepo);
  });

  group('SendUserNotificationUseCase', () {
    test('should call repo.sendNotification with input entity and return NetworkSuccess with created NotificationEntity', () async {
      // Arrange
      when(() => mockUsersRepo.sendNotification(any()))
          .thenAnswer((_) async => NetworkSuccess(tNotification));

      // Act
      final result = await sut(tInput);

      // Assert
      expect(result, isA<NetworkSuccess<NotificationEntity>>());
      final entity = (result as NetworkSuccess<NotificationEntity>).data!;
      expect(entity, tNotification);
      expect(entity.id, 'notif_created_123');
      expect(entity.titleAr, 'إشعار جديد');

      verify(() => mockUsersRepo.sendNotification(tInput)).called(1);
      verifyNoMoreInteractions(mockUsersRepo);
    });

    test(
      'should return NetworkFailure when repo call returns failure',
      () async {
        // Arrange
        when(() => mockUsersRepo.sendNotification(any()))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(tInput);

        // Assert
        expect(result, isA<NetworkFailure<NotificationEntity>>());
        final failure = (result as NetworkFailure<NotificationEntity>).failure;
        expect(failure.error, tFailure.error);

        verify(() => mockUsersRepo.sendNotification(tInput)).called(1);
        verifyNoMoreInteractions(mockUsersRepo);
      },
    );
  });
}
