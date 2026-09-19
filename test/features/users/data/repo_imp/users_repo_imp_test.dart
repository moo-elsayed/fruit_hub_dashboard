import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';
import 'package:fruit_hub_dashboard/core/enums/user_filter_type.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/data/data_sources/remote/users_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/cart_item_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/dashboard_user_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/notification_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/send_notification_input_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/users_page_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/users_stats_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/repo_imp/users_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/dashboard_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/notification_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/send_notification_input_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/users_page_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/users_stats_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRemoteDataSource extends Mock implements UsersRemoteDataSource {}

class FakeSendNotificationInputModel extends Fake
    implements SendNotificationInputModel {}

void main() {
  late MockUsersRemoteDataSource mockRemoteDataSource;
  late UsersRepoImp sut;

  const tFailure = ServerFailure(error: 'Network connection failure');

  final tUserModel = DashboardUserModel(
    uid: 'user_1',
    name: 'Ahmed Mohamed',
    email: 'ahmed@test.com',
    phone: '01012345678',
    image: 'https://example.com/avatar.png',
    isVerified: true,
    languageCode: 'ar',
    fcmToken: 'fcm_123',
    lastTokenUpdate: DateTime(2026, 9, 18, 10, 0),
    cartItems: const [CartItemModel(productId: 'item_1', quantity: 2)],
    favoriteIds: const ['fav_1'],
  );

  final tUsersPageModel = UsersPageModel(
    users: [tUserModel],
    hasMore: true,
    lastDocument: null,
  );

  const tUsersStatsModel = UsersStatsModel(
    totalCount: 20,
    verifiedCount: 15,
    activeCartCount: 8,
  );

  final tNotificationModel = NotificationModel(
    id: 'notif_1',
    titleAr: 'عنوان',
    titleEn: 'Title',
    bodyAr: 'محتوى',
    bodyEn: 'Body',
    type: NotificationType.general,
    isRead: false,
    createdAt: DateTime(2026, 9, 18, 12, 0),
  );

  const tSendNotificationInputEntity = SendNotificationInputEntity(
    userId: 'user_1',
    titleAr: 'تنبيه',
    titleEn: 'Alert',
    bodyAr: 'محتوى التنبيه',
    bodyEn: 'Alert body',
    type: NotificationType.general,
  );

  setUpAll(() {
    registerFallbackValue(FakeSendNotificationInputModel());
    registerFallbackValue(UserFilterType.all);
    registerFallbackValue(UserSearchBy.name);
  });

  setUp(() {
    mockRemoteDataSource = MockUsersRemoteDataSource();
    sut = UsersRepoImp(mockRemoteDataSource);
  });

  group('UsersRepoImp', () {
    group('getUsers', () {
      test('should return NetworkSuccess with mapped UsersPageEntity when remote data source returns NetworkSuccess', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getUsers(
            limit: any(named: 'limit'),
            lastDocument: any(named: 'lastDocument'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async => NetworkSuccess(tUsersPageModel));

        // Act
        final result = await sut.getUsers(
          limit: 10,
          filter: UserFilterType.verified,
        );

        // Assert
        expect(result, isA<NetworkSuccess<UsersPageEntity>>());
        final entity = (result as NetworkSuccess<UsersPageEntity>).data!;
        expect(entity.users.length, 1);
        expect(entity.users.first.uid, 'user_1');
        expect(entity.users.first.name, 'Ahmed Mohamed');
        expect(entity.hasMore, isTrue);

        verify(
          () => mockRemoteDataSource.getUsers(
            limit: 10,
            lastDocument: null,
            filter: UserFilterType.verified,
          ),
        ).called(1);
      });

      test('should return default empty UsersPageEntity when NetworkSuccess data is null', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getUsers(
            limit: any(named: 'limit'),
            lastDocument: any(named: 'lastDocument'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.getUsers();

        // Assert
        expect(result, isA<NetworkSuccess<UsersPageEntity>>());
        final entity = (result as NetworkSuccess<UsersPageEntity>).data!;
        expect(entity.users, isEmpty);
        expect(entity.hasMore, isFalse);
      });

      test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getUsers(
            limit: any(named: 'limit'),
            lastDocument: any(named: 'lastDocument'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.getUsers();

        // Assert
        expect(result, isA<NetworkFailure<UsersPageEntity>>());
        final failure = (result as NetworkFailure<UsersPageEntity>).failure;
        expect(failure.error, tFailure.error);
      });
    });

    group('getUsersStats', () {
      test('should return NetworkSuccess with mapped UsersStatsEntity when remote data source returns NetworkSuccess', () async {
        // Arrange
        when(() => mockRemoteDataSource.getUsersStats())
            .thenAnswer((_) async => const NetworkSuccess(tUsersStatsModel));

        // Act
        final result = await sut.getUsersStats();

        // Assert
        expect(result, isA<NetworkSuccess<UsersStatsEntity>>());
        final entity = (result as NetworkSuccess<UsersStatsEntity>).data!;
        expect(entity.totalCount, 20);
        expect(entity.verifiedCount, 15);
        expect(entity.activeCartCount, 8);

        verify(() => mockRemoteDataSource.getUsersStats()).called(1);
      });

      test('should return fallback default UsersStatsEntity when NetworkSuccess data is null', () async {
        // Arrange
        when(() => mockRemoteDataSource.getUsersStats())
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.getUsersStats();

        // Assert
        expect(result, isA<NetworkSuccess<UsersStatsEntity>>());
        final entity = (result as NetworkSuccess<UsersStatsEntity>).data!;
        expect(entity.totalCount, 0);
        expect(entity.verifiedCount, 0);
        expect(entity.activeCartCount, 0);
      });

      test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
        // Arrange
        when(() => mockRemoteDataSource.getUsersStats())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.getUsersStats();

        // Assert
        expect(result, isA<NetworkFailure<UsersStatsEntity>>());
        final failure = (result as NetworkFailure<UsersStatsEntity>).failure;
        expect(failure.error, tFailure.error);
      });
    });

    group('getUserNotifications', () {
      const tUserId = 'user_1';

      test('should return NetworkSuccess with mapped NotificationEntities when remote returns NetworkSuccess', () async {
        // Arrange
        when(() => mockRemoteDataSource.getUserNotifications(tUserId))
            .thenAnswer((_) async => NetworkSuccess([tNotificationModel]));

        // Act
        final result = await sut.getUserNotifications(tUserId);

        // Assert
        expect(result, isA<NetworkSuccess<List<NotificationEntity>>>());
        final list = (result as NetworkSuccess<List<NotificationEntity>>).data!;
        expect(list.length, 1);
        expect(list.first.id, 'notif_1');
        expect(list.first.titleAr, 'عنوان');
        expect(list.first.titleEn, 'Title');

        verify(() => mockRemoteDataSource.getUserNotifications(tUserId))
            .called(1);
      });

      test(
        'should return empty list when NetworkSuccess data is null',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.getUserNotifications(tUserId))
              .thenAnswer((_) async => const NetworkSuccess(null));

          // Act
          final result = await sut.getUserNotifications(tUserId);

          // Assert
          expect(result, isA<NetworkSuccess<List<NotificationEntity>>>());
          final list =
              (result as NetworkSuccess<List<NotificationEntity>>).data!;
          expect(list, isEmpty);
        },
      );

      test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
        // Arrange
        when(() => mockRemoteDataSource.getUserNotifications(tUserId))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.getUserNotifications(tUserId);

        // Assert
        expect(result, isA<NetworkFailure<List<NotificationEntity>>>());
        final failure =
            (result as NetworkFailure<List<NotificationEntity>>).failure;
        expect(failure.error, tFailure.error);
      });
    });

    group('searchUsers', () {
      test('should return NetworkSuccess with mapped DashboardUserEntities when remote returns NetworkSuccess', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.searchUsers(
            query: any(named: 'query'),
            searchBy: any(named: 'searchBy'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => NetworkSuccess([tUserModel]));

        // Act
        final result = await sut.searchUsers(
          query: 'Ahmed',
          searchBy: UserSearchBy.name,
          limit: 20,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<DashboardUserEntity>>>());
        final list =
            (result as NetworkSuccess<List<DashboardUserEntity>>).data!;
        expect(list.length, 1);
        expect(list.first.uid, 'user_1');
        expect(list.first.name, 'Ahmed Mohamed');

        verify(
          () => mockRemoteDataSource.searchUsers(
            query: 'Ahmed',
            searchBy: UserSearchBy.name,
            limit: 20,
          ),
        ).called(1);
      });

      test(
        'should return empty list when NetworkSuccess data is null',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.searchUsers(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));

          // Act
          final result = await sut.searchUsers(
            query: 'test',
            searchBy: UserSearchBy.email,
          );

          // Assert
          expect(result, isA<NetworkSuccess<List<DashboardUserEntity>>>());
          final list =
              (result as NetworkSuccess<List<DashboardUserEntity>>).data!;
          expect(list, isEmpty);
        },
      );

      test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.searchUsers(
            query: any(named: 'query'),
            searchBy: any(named: 'searchBy'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.searchUsers(
          query: '010',
          searchBy: UserSearchBy.phone,
        );

        // Assert
        expect(result, isA<NetworkFailure<List<DashboardUserEntity>>>());
        final failure =
            (result as NetworkFailure<List<DashboardUserEntity>>).failure;
        expect(failure.error, tFailure.error);
      });
    });

    group('sendNotification', () {
      test('should convert input entity to model, call remoteDataSource, and return NetworkSuccess with mapped entity', () async {
        // Arrange
        when(() => mockRemoteDataSource.sendNotification(any()))
            .thenAnswer((_) async => NetworkSuccess(tNotificationModel));

        // Act
        final result = await sut.sendNotification(tSendNotificationInputEntity);

        // Assert
        expect(result, isA<NetworkSuccess<NotificationEntity>>());
        final entity = (result as NetworkSuccess<NotificationEntity>).data;
        expect(entity, isNotNull);
        expect(entity!.id, 'notif_1');
        expect(entity.titleAr, 'عنوان');
        expect(entity.type, NotificationType.general);

        verify(
          () => mockRemoteDataSource.sendNotification(
            any(
              that: isA<SendNotificationInputModel>()
                  .having((m) => m.userId, 'userId', 'user_1')
                  .having((m) => m.titleAr, 'titleAr', 'تنبيه')
                  .having((m) => m.type, 'type', 'general'),
            ),
          ),
        ).called(1);
      });

      test('should return NetworkSuccess with null data when remote returns null model', () async {
        // Arrange
        when(() => mockRemoteDataSource.sendNotification(any()))
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.sendNotification(tSendNotificationInputEntity);

        // Assert
        expect(result, isA<NetworkSuccess<NotificationEntity>>());
        final entity = (result as NetworkSuccess<NotificationEntity>).data;
        expect(entity, isNull);
      });

      test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
        // Arrange
        when(() => mockRemoteDataSource.sendNotification(any()))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.sendNotification(tSendNotificationInputEntity);

        // Assert
        expect(result, isA<NetworkFailure<NotificationEntity>>());
        final failure = (result as NetworkFailure<NotificationEntity>).failure;
        expect(failure.error, tFailure.error);
      });
    });
  });
}
