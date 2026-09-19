import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';
import 'package:fruit_hub_dashboard/core/enums/user_filter_type.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/data/data_sources/remote/users_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/dashboard_user_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/notification_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/send_notification_input_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/users_page_model.dart';
import 'package:fruit_hub_dashboard/features/users/data/models/users_stats_model.dart';

void main() {
  group('UsersRemoteDataSourceImp', () {
    late FakeFirebaseFirestore fakeFirestore;
    late UsersRemoteDataSourceImp sut;

    const usersCollection = BackendEndpoints.usersCollection;

    Map<String, dynamic> createUserMap({
      String uid = 'user_1',
      String name = 'Ahmed Mohamed',
      String email = 'ahmed@example.com',
      String phone = '01012345678',
      String image = 'https://example.com/avatar.png',
      bool isVerified = false,
      String languageCode = 'ar',
      String fcmToken = 'fcm_token_123',
      dynamic lastTokenUpdate,
      List<dynamic> cartItems = const [],
      List<dynamic> favoriteIds = const [],
    }) => {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'isVerified': isVerified,
      'languageCode': languageCode,
      'fcmToken': fcmToken,
      'lastTokenUpdate': ?lastTokenUpdate,
      if (cartItems.isNotEmpty) 'cartItems': cartItems,
      if (favoriteIds.isNotEmpty) 'favoriteIds': favoriteIds,
    };

    Map<String, dynamic> createNotificationMap({
      String titleAr = 'عنوان الإشعار',
      String titleEn = 'Notification Title',
      String bodyAr = 'محتوى الإشعار',
      String bodyEn = 'Notification Body',
      String type = 'general',
      bool isRead = false,
      dynamic createdAt,
      String? orderId,
      String? status,
      String? productCode,
    }) => {
      'titleAr': titleAr,
      'titleEn': titleEn,
      'bodyAr': bodyAr,
      'bodyEn': bodyEn,
      'type': type,
      'isRead': isRead,
      'createdAt': ?createdAt,
      'orderId': ?orderId,
      'status': ?status,
      'productCode': ?productCode,
    };

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      sut = UsersRemoteDataSourceImp(firestore: fakeFirestore);
    });

    group('getUsers', () {
      test('should return NetworkSuccess with empty users list and hasMore false when collection is empty', () async {
        // Act
        final response = await sut.getUsers();

        // Assert
        expect(response, isA<NetworkSuccess<UsersPageModel>>());
        final page = (response as NetworkSuccess<UsersPageModel>).data!;
        expect(page.users, isEmpty);
        expect(page.hasMore, isFalse);
        expect(page.lastDocument, isNull);
      });

      test('should return NetworkSuccess with properly mapped DashboardUserModel list when documents exist', () async {
        // Arrange
        final tokenDate = DateTime(2026, 9, 17, 12, 0);
        final userMap = createUserMap(
          uid: 'u_101',
          name: 'Kareem Tarek',
          email: 'kareem@test.com',
          phone: '01123456789',
          image: 'https://example.com/kareem.jpg',
          isVerified: true,
          languageCode: 'en',
          fcmToken: 'token_abc',
          lastTokenUpdate: Timestamp.fromDate(tokenDate),
          cartItems: [
            {'fruitCode': 'APL', 'quantity': 3},
          ],
          favoriteIds: ['fav_1', 'fav_2'],
        );

        await fakeFirestore
            .collection(usersCollection)
            .doc('u_101')
            .set(userMap);

        // Act
        final response = await sut.getUsers();

        // Assert
        expect(response, isA<NetworkSuccess<UsersPageModel>>());
        final page = (response as NetworkSuccess<UsersPageModel>).data!;
        expect(page.users.length, 1);

        final user = page.users.first;
        expect(user.uid, 'u_101');
        expect(user.name, 'Kareem Tarek');
        expect(user.email, 'kareem@test.com');
        expect(user.phone, '01123456789');
        expect(user.image, 'https://example.com/kareem.jpg');
        expect(user.isVerified, isTrue);
        expect(user.languageCode, 'en');
        expect(user.fcmToken, 'token_abc');
        expect(user.lastTokenUpdate, tokenDate);
        expect(user.cartItems.length, 1);
        expect(user.cartItems.first.productId, 'APL');
        expect(user.cartItems.first.quantity, 3);
        expect(user.favoriteIds, ['fav_1', 'fav_2']);
        expect(page.hasMore, isFalse);
        expect(page.lastDocument, isNotNull);
        expect(page.lastDocument!.id, 'u_101');
      });

      test('should fallback to default values when optional user fields are missing or use alternative keys', () async {
        // Arrange - using phoneNumber, photoUrl, String date, docId as uid
        await fakeFirestore
            .collection(usersCollection)
            .doc('fallback_doc_id')
            .set({
              'phoneNumber': '01099998888',
              'photoUrl': 'https://example.com/alt_photo.png',
              'lastTokenUpdate': '2026-09-17T15:30:00.000Z',
            });

        // Act
        final response = await sut.getUsers();

        // Assert
        expect(response, isA<NetworkSuccess<UsersPageModel>>());
        final page = (response as NetworkSuccess<UsersPageModel>).data!;
        expect(page.users.length, 1);

        final user = page.users.first;
        expect(user.uid, 'fallback_doc_id');
        expect(user.name, '');
        expect(user.email, '');
        expect(user.phone, '01099998888');
        expect(user.image, 'https://example.com/alt_photo.png');
        expect(user.isVerified, isFalse);
        expect(user.languageCode, 'ar');
        expect(user.fcmToken, '');
        expect(
          user.lastTokenUpdate,
          DateTime.parse('2026-09-17T15:30:00.000Z'),
        );
        expect(user.cartItems, isEmpty);
        expect(user.favoriteIds, isEmpty);
      });

      test(
        'should set hasMore to true when returned documents count equals limit',
        () async {
          // Arrange
          for (int i = 1; i <= 3; i++) {
            await fakeFirestore
                .collection(usersCollection)
                .doc('user_$i')
                .set(createUserMap(uid: 'user_$i', name: 'User $i'));
          }

          // Act - limit is 3, total is 3
          final response = await sut.getUsers(limit: 3);

          // Assert
          expect(response, isA<NetworkSuccess<UsersPageModel>>());
          final page = (response as NetworkSuccess<UsersPageModel>).data!;
          expect(page.users.length, 3);
          expect(page.hasMore, isTrue);
        },
      );

      test('should set hasMore to false when returned documents count is less than limit', () async {
        // Arrange
        for (int i = 1; i <= 2; i++) {
          await fakeFirestore
              .collection(usersCollection)
              .doc('user_$i')
              .set(createUserMap(uid: 'user_$i', name: 'User $i'));
        }

        // Act - limit is 5, total is 2
        final response = await sut.getUsers(limit: 5);

        // Assert
        expect(response, isA<NetworkSuccess<UsersPageModel>>());
        final page = (response as NetworkSuccess<UsersPageModel>).data!;
        expect(page.users.length, 2);
        expect(page.hasMore, isFalse);
      });

      test('should paginate properly when lastDocument is provided', () async {
        // Arrange
        for (int i = 1; i <= 4; i++) {
          await fakeFirestore
              .collection(usersCollection)
              .doc('user_$i')
              .set(createUserMap(uid: 'user_$i', name: 'User $i'));
        }

        // First page: limit 2
        final firstPageResponse = await sut.getUsers(limit: 2);
        final firstPage =
            (firstPageResponse as NetworkSuccess<UsersPageModel>).data!;
        expect(firstPage.users.length, 2);
        expect(firstPage.hasMore, isTrue);
        final lastDoc = firstPage.lastDocument;
        expect(lastDoc, isNotNull);

        // Second page: startAfterDocument
        final secondPageResponse = await sut.getUsers(
          limit: 2,
          lastDocument: lastDoc,
        );
        final secondPage =
            (secondPageResponse as NetworkSuccess<UsersPageModel>).data!;
        expect(secondPage.users.length, 2);
        expect(
          secondPage.users.map((u) => u.uid).toList(),
          isNot(contains(firstPage.users.first.uid)),
        );
      });

      test(
        'should filter by UserFilterType.all and return all users',
        () async {
          // Arrange
          await fakeFirestore
              .collection(usersCollection)
              .doc('u1')
              .set(
                createUserMap(
                  uid: 'u1',
                  isVerified: true,
                  cartItems: [
                    {'code': 'A'},
                  ],
                ),
              );
          await fakeFirestore
              .collection(usersCollection)
              .doc('u2')
              .set(createUserMap(uid: 'u2', isVerified: false, cartItems: []));

          // Act
          final response = await sut.getUsers(filter: UserFilterType.all);

          // Assert
          expect(response, isA<NetworkSuccess<UsersPageModel>>());
          final page = (response as NetworkSuccess<UsersPageModel>).data!;
          expect(page.users.length, 2);
        },
      );

      test('should filter by UserFilterType.verified and return only verified users', () async {
        // Arrange
        await fakeFirestore
            .collection(usersCollection)
            .doc('u1')
            .set(
              createUserMap(uid: 'u1', name: 'Verified User', isVerified: true),
            );
        await fakeFirestore
            .collection(usersCollection)
            .doc('u2')
            .set(
              createUserMap(
                uid: 'u2',
                name: 'Unverified User',
                isVerified: false,
              ),
            );

        // Act
        final response = await sut.getUsers(filter: UserFilterType.verified);

        // Assert
        expect(response, isA<NetworkSuccess<UsersPageModel>>());
        final page = (response as NetworkSuccess<UsersPageModel>).data!;
        expect(page.users.length, 1);
        expect(page.users.first.uid, 'u1');
        expect(page.users.first.isVerified, isTrue);
      });

      test('should filter by UserFilterType.withCart and return only users with active cart items', () async {
        // Arrange
        await fakeFirestore
            .collection(usersCollection)
            .doc('u1')
            .set(
              createUserMap(
                uid: 'u1',
                cartItems: [
                  {'name': 'Orange', 'price': 10.0, 'quantity': 1},
                ],
              ),
            );
        await fakeFirestore
            .collection(usersCollection)
            .doc('u2')
            .set(createUserMap(uid: 'u2', cartItems: []));

        // Act
        final response = await sut.getUsers(filter: UserFilterType.withCart);

        // Assert
        expect(response, isA<NetworkSuccess<UsersPageModel>>());
        final page = (response as NetworkSuccess<UsersPageModel>).data!;
        expect(page.users.length, 1);
        expect(page.users.first.uid, 'u1');
        expect(page.users.first.cartItems, isNotEmpty);
      });
    });

    group('getUsersStats', () {
      test('should return all zeros when users collection is empty', () async {
        // Act
        final response = await sut.getUsersStats();

        // Assert
        expect(response, isA<NetworkSuccess<UsersStatsModel>>());
        final stats = (response as NetworkSuccess<UsersStatsModel>).data!;
        expect(stats.totalCount, 0);
        expect(stats.verifiedCount, 0);
        expect(stats.activeCartCount, 0);
      });

      test('should return accurate counts for total, verified, and activeCart users', () async {
        // Arrange
        // User 1: verified, with cart
        await fakeFirestore
            .collection(usersCollection)
            .doc('u1')
            .set(
              createUserMap(
                uid: 'u1',
                isVerified: true,
                cartItems: [
                  {'code': 'ITEM1'},
                ],
              ),
            );
        // User 2: verified, no cart
        await fakeFirestore
            .collection(usersCollection)
            .doc('u2')
            .set(createUserMap(uid: 'u2', isVerified: true, cartItems: []));
        // User 3: unverified, with cart
        await fakeFirestore
            .collection(usersCollection)
            .doc('u3')
            .set(
              createUserMap(
                uid: 'u3',
                isVerified: false,
                cartItems: [
                  {'code': 'ITEM2'},
                ],
              ),
            );
        // User 4: unverified, no cart
        await fakeFirestore
            .collection(usersCollection)
            .doc('u4')
            .set(createUserMap(uid: 'u4', isVerified: false, cartItems: []));

        // Act
        final response = await sut.getUsersStats();

        // Assert
        expect(response, isA<NetworkSuccess<UsersStatsModel>>());
        final stats = (response as NetworkSuccess<UsersStatsModel>).data!;
        expect(stats.totalCount, 4);
        expect(stats.verifiedCount, 2);
        expect(stats.activeCartCount, 2);
      });
    });

    group('getUserNotifications', () {
      const testUserId = 'test_user_id';

      test('should return empty list when user has no notifications', () async {
        // Act
        final response = await sut.getUserNotifications(testUserId);

        // Assert
        expect(response, isA<NetworkSuccess<List<NotificationModel>>>());
        final list =
            (response as NetworkSuccess<List<NotificationModel>>).data!;
        expect(list, isEmpty);
      });

      test(
        'should return notifications ordered descending by createdAt',
        () async {
          // Arrange
          final olderDate = DateTime(2026, 9, 10, 10, 0);
          final newerDate = DateTime(2026, 9, 15, 12, 0);

          final notifCol = fakeFirestore
              .collection(usersCollection)
              .doc(testUserId)
              .collection('notifications');

          await notifCol
              .doc('notif_1')
              .set(
                createNotificationMap(
                  titleAr: 'قديم',
                  titleEn: 'Old',
                  createdAt: Timestamp.fromDate(olderDate),
                ),
              );
          await notifCol
              .doc('notif_2')
              .set(
                createNotificationMap(
                  titleAr: 'جديد',
                  titleEn: 'New',
                  createdAt: Timestamp.fromDate(newerDate),
                ),
              );

          // Act
          final response = await sut.getUserNotifications(testUserId);

          // Assert
          expect(response, isA<NetworkSuccess<List<NotificationModel>>>());
          final list =
              (response as NetworkSuccess<List<NotificationModel>>).data!;
          expect(list.length, 2);
          expect(list[0].id, 'notif_2');
          expect(list[0].titleAr, 'جديد');
          expect(list[1].id, 'notif_1');
          expect(list[1].titleAr, 'قديم');
        },
      );

      test('should correctly parse full notification details including optional fields', () async {
        // Arrange
        final date = DateTime(2026, 9, 17, 18, 30);
        final notifMap = createNotificationMap(
          titleAr: 'تحديث الطلب',
          titleEn: 'Order Update',
          bodyAr: 'تم شحن طلبك',
          bodyEn: 'Your order was shipped',
          type: 'order',
          isRead: true,
          createdAt: Timestamp.fromDate(date),
          orderId: 'ORD_999',
          status: 'shipped',
          productCode: 'PROD_123',
        );

        await fakeFirestore
            .collection(usersCollection)
            .doc(testUserId)
            .collection('notifications')
            .doc('doc_full')
            .set(notifMap);

        // Act
        final response = await sut.getUserNotifications(testUserId);

        // Assert
        expect(response, isA<NetworkSuccess<List<NotificationModel>>>());
        final list =
            (response as NetworkSuccess<List<NotificationModel>>).data!;
        expect(list.length, 1);

        final notif = list.first;
        expect(notif.id, 'doc_full');
        expect(notif.titleAr, 'تحديث الطلب');
        expect(notif.titleEn, 'Order Update');
        expect(notif.bodyAr, 'تم شحن طلبك');
        expect(notif.bodyEn, 'Your order was shipped');
        expect(notif.type, NotificationType.order);
        expect(notif.isRead, isTrue);
        expect(notif.orderId, 'ORD_999');
        expect(notif.status, 'shipped');
        expect(notif.productCode, 'PROD_123');
        expect(notif.createdAt, date);
      });

      test('should fallback to single title and body fields when bilingual fields are absent', () async {
        // Arrange
        await fakeFirestore
            .collection(usersCollection)
            .doc(testUserId)
            .collection('notifications')
            .doc('legacy_notif')
            .set({
              'title': 'Legacy Title',
              'body': 'Legacy Body',
              'type': 'system',
              'createdAt': '2026-09-17T12:00:00.000Z',
            });

        // Act
        final response = await sut.getUserNotifications(testUserId);

        // Assert
        expect(response, isA<NetworkSuccess<List<NotificationModel>>>());
        final list =
            (response as NetworkSuccess<List<NotificationModel>>).data!;
        expect(list.length, 1);

        final notif = list.first;
        expect(notif.titleAr, 'Legacy Title');
        expect(notif.titleEn, 'Legacy Title');
        expect(notif.bodyAr, 'Legacy Body');
        expect(notif.bodyEn, 'Legacy Body');
        expect(notif.type, NotificationType.general);
        expect(notif.isRead, isFalse);
        expect(notif.createdAt, DateTime.parse('2026-09-17T12:00:00.000Z'));
      });

      test(
        'should correctly parse all notification types from Firestore',
        () async {
          final notifCol = fakeFirestore
              .collection(usersCollection)
              .doc(testUserId)
              .collection('notifications');

          for (final type in NotificationType.values) {
            await notifCol.doc('notif_${type.name}').set({
              'title': 'Test ${type.name}',
              'body': 'Body ${type.name}',
              'type': type.value,
              'createdAt': Timestamp.now(),
            });
          }

          final response = await sut.getUserNotifications(testUserId);
          expect(response, isA<NetworkSuccess<List<NotificationModel>>>());
          final list =
              (response as NetworkSuccess<List<NotificationModel>>).data!;
          final types = list.map((e) => e.type).toSet();
          expect(types, containsAll(NotificationType.values));
        },
      );
    });

    group('searchUsers', () {
      setUp(() async {
        await fakeFirestore
            .collection(usersCollection)
            .doc('u1')
            .set(
              createUserMap(
                uid: 'u1',
                name: 'Ahmed Hassan',
                email: 'ahmed@test.com',
                phone: '01011112222',
              ),
            );
        await fakeFirestore
            .collection(usersCollection)
            .doc('u2')
            .set(
              createUserMap(
                uid: 'u2',
                name: 'Amr Khaled',
                email: 'amr@test.com',
                phone: '01033334444',
              ),
            );
        await fakeFirestore
            .collection(usersCollection)
            .doc('u3')
            .set(
              createUserMap(
                uid: 'u3',
                name: 'Mohamed Ali',
                email: 'mohamed@test.com',
                phone: '01255556666',
              ),
            );
      });

      test(
        'should return empty list without querying when query string is empty',
        () async {
          // Act
          final response = await sut.searchUsers(
            query: '',
            searchBy: UserSearchBy.name,
          );

          // Assert
          expect(response, isA<NetworkSuccess<List<DashboardUserModel>>>());
          final users =
              (response as NetworkSuccess<List<DashboardUserModel>>).data!;
          expect(users, isEmpty);
        },
      );

      test(
        'should return empty list when query consists only of whitespace',
        () async {
          // Act
          final response = await sut.searchUsers(
            query: '    ',
            searchBy: UserSearchBy.email,
          );

          // Assert
          expect(response, isA<NetworkSuccess<List<DashboardUserModel>>>());
          final users =
              (response as NetworkSuccess<List<DashboardUserModel>>).data!;
          expect(users, isEmpty);
        },
      );

      test(
        'should search by email (case-insensitive) and return matching users',
        () async {
          // Act
          final response = await sut.searchUsers(
            query: 'AHMED',
            searchBy: UserSearchBy.email,
          );

          // Assert
          expect(response, isA<NetworkSuccess<List<DashboardUserModel>>>());
          final users =
              (response as NetworkSuccess<List<DashboardUserModel>>).data!;
          expect(users.length, 1);
          expect(users.first.email, 'ahmed@test.com');
        },
      );

      test('should search by phone and return matching users', () async {
        // Act
        final response = await sut.searchUsers(
          query: '010',
          searchBy: UserSearchBy.phone,
        );

        // Assert
        expect(response, isA<NetworkSuccess<List<DashboardUserModel>>>());
        final users =
            (response as NetworkSuccess<List<DashboardUserModel>>).data!;
        expect(users.length, 2);
        final phones = users.map((u) => u.phone).toList();
        expect(phones, containsAll(['01011112222', '01033334444']));
      });

      test('should search by name and return matching users', () async {
        // Act
        final response = await sut.searchUsers(
          query: 'Mohamed',
          searchBy: UserSearchBy.name,
        );

        // Assert
        expect(response, isA<NetworkSuccess<List<DashboardUserModel>>>());
        final users =
            (response as NetworkSuccess<List<DashboardUserModel>>).data!;
        expect(users.length, 1);
        expect(users.first.name, 'Mohamed Ali');
      });

      test('should respect limit parameter during search', () async {
        // Act
        final response = await sut.searchUsers(
          query: '010',
          searchBy: UserSearchBy.phone,
          limit: 1,
        );

        // Assert
        expect(response, isA<NetworkSuccess<List<DashboardUserModel>>>());
        final users =
            (response as NetworkSuccess<List<DashboardUserModel>>).data!;
        expect(users.length, 1);
      });

      test(
        'should return empty list when no users match search query',
        () async {
          // Act
          final response = await sut.searchUsers(
            query: 'NonExistent',
            searchBy: UserSearchBy.name,
          );

          // Assert
          expect(response, isA<NetworkSuccess<List<DashboardUserModel>>>());
          final users =
              (response as NetworkSuccess<List<DashboardUserModel>>).data!;
          expect(users, isEmpty);
        },
      );
    });

    group('sendNotification', () {
      const input = SendNotificationInputModel(
        userId: 'target_user_123',
        titleAr: 'خصم خاص',
        titleEn: 'Special Discount',
        bodyAr: 'احصل على خصم 20%',
        bodyEn: 'Get 20% off',
        type: 'general',
      );

      test('should create notification document in Firestore and return NotificationModel', () async {
        // Act
        final response = await sut.sendNotification(input);

        // Assert
        expect(response, isA<NetworkSuccess<NotificationModel>>());
        final notif = (response as NetworkSuccess<NotificationModel>).data!;
        expect(notif.id, isNotEmpty);
        expect(notif.titleAr, input.titleAr);
        expect(notif.titleEn, input.titleEn);
        expect(notif.bodyAr, input.bodyAr);
        expect(notif.bodyEn, input.bodyEn);
        expect(notif.type, NotificationType.general);
        expect(notif.isRead, isFalse);
        expect(notif.createdAt, isNotNull);

        // Verify in Firestore
        final doc = await fakeFirestore
            .collection(usersCollection)
            .doc(input.userId)
            .collection('notifications')
            .doc(notif.id)
            .get();

        expect(doc.exists, isTrue);
        final data = doc.data()!;
        expect(data['titleAr'], input.titleAr);
        expect(data['titleEn'], input.titleEn);
        expect(data['bodyAr'], input.bodyAr);
        expect(data['bodyEn'], input.bodyEn);
        expect(data['type'], 'general');
        expect(data['isRead'], isFalse);
        expect(data['source'], 'admin_dashboard');
        expect(data['pushSent'], isFalse);
        expect(data['createdAt'], isNotNull);
      });

      for (final type in NotificationType.values) {
        test(
          'should send notification with NotificationType.${type.name} successfully',
          () async {
            final typeInput = SendNotificationInputModel(
              userId: 'user_${type.name}',
              titleAr: 'عنوان ${type.name}',
              titleEn: 'Title ${type.name}',
              bodyAr: 'محتوى ${type.name}',
              bodyEn: 'Body ${type.name}',
              type: type.value,
            );

            final response = await sut.sendNotification(typeInput);

            expect(response, isA<NetworkSuccess<NotificationModel>>());
            final notif = (response as NetworkSuccess<NotificationModel>).data!;
            expect(notif.type, type);

            final doc = await fakeFirestore
                .collection(usersCollection)
                .doc(typeInput.userId)
                .collection('notifications')
                .doc(notif.id)
                .get();

            expect(doc.data()!['type'], type.value);
          },
        );
      }
    });

    group('Model to Entity mappings', () {
      test('DashboardUserModel.toEntity should map all fields correctly', () {
        final date = DateTime(2026, 9, 18, 10, 0);
        final model = DashboardUserModel(
          uid: 'u_test',
          name: 'Name',
          email: 'test@email.com',
          phone: '01000000000',
          image: 'https://img.com',
          isVerified: true,
          languageCode: 'en',
          fcmToken: 'fcm',
          lastTokenUpdate: date,
          cartItems: const [],
          favoriteIds: const ['fav_1'],
        );

        final entity = model.toEntity();

        expect(entity.uid, model.uid);
        expect(entity.name, model.name);
        expect(entity.email, model.email);
        expect(entity.phone, model.phone);
        expect(entity.image, model.image);
        expect(entity.isVerified, model.isVerified);
        expect(entity.languageCode, model.languageCode);
        expect(entity.fcmToken, model.fcmToken);
        expect(entity.lastTokenUpdate, model.lastTokenUpdate);
        expect(entity.cartItems, isEmpty);
        expect(entity.favoriteIds, model.favoriteIds);
      });

      test('UsersPageModel.toEntity should map all fields correctly', () {
        const model = UsersPageModel(
          users: [],
          hasMore: true,
          lastDocument: null,
        );

        final entity = model.toEntity();

        expect(entity.users, isEmpty);
        expect(entity.hasMore, isTrue);
        expect(entity.lastDocument, isNull);
      });

      test('UsersStatsModel.toEntity should map all fields correctly', () {
        const model = UsersStatsModel(
          totalCount: 10,
          verifiedCount: 5,
          activeCartCount: 3,
        );

        final entity = model.toEntity();

        expect(entity.totalCount, 10);
        expect(entity.verifiedCount, 5);
        expect(entity.activeCartCount, 3);
      });

      test('NotificationModel.toEntity and toJson should work correctly', () {
        final date = DateTime(2026, 9, 18, 10, 0);
        final model = NotificationModel(
          id: 'n_1',
          titleAr: 'ع',
          titleEn: 'T',
          bodyAr: 'م',
          bodyEn: 'B',
          type: NotificationType.order,
          isRead: true,
          orderId: 'ORD_1',
          status: 'shipped',
          productCode: 'PR_1',
          createdAt: date,
        );

        final entity = model.toEntity();
        expect(entity.id, model.id);
        expect(entity.titleAr, model.titleAr);
        expect(entity.titleEn, model.titleEn);
        expect(entity.type, model.type);
        expect(entity.isRead, isTrue);
        expect(entity.orderId, 'ORD_1');
        expect(entity.status, 'shipped');
        expect(entity.productCode, 'PR_1');
        expect(entity.createdAt, date);

        final json = model.toJson();
        expect(json['titleAr'], 'ع');
        expect(json['titleEn'], 'T');
        expect(json['type'], 'order');
        expect(json['isRead'], isTrue);
        expect(json['orderId'], 'ORD_1');
        expect(json['status'], 'shipped');
        expect(json['productCode'], 'PR_1');
        expect(json['createdAt'], isA<Timestamp>());
      });
    });
  });
}
