import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/dashboard_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/users_page_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/users_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_users_stats_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_users_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/users_cubit/users_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

class MockGetUsersStatsUseCase extends Mock implements GetUsersStatsUseCase {}

void main() {
  late MockGetUsersUseCase mockGetUsersUseCase;
  late MockGetUsersStatsUseCase mockGetUsersStatsUseCase;
  late UsersCubit sut;
  late DocumentSnapshot fakeDoc;
  late UsersPageEntity tPage1;

  const tErrorMessage = 'Failed to load users';
  const tFailure = ServerFailure(error: tErrorMessage);

  const tStats = UsersStatsEntity(
    totalCount: 30,
    verifiedCount: 20,
    activeCartCount: 10,
  );

  const tUser1 = DashboardUserEntity(
    uid: 'u_1',
    name: 'Ahmed',
    email: 'ahmed@test.com',
    phone: '01011112222',
  );

  const tUser2 = DashboardUserEntity(
    uid: 'u_2',
    name: 'Mohamed',
    email: 'mohamed@test.com',
    phone: '01033334444',
  );

  const tUser3 = DashboardUserEntity(
    uid: 'u_3',
    name: 'Ali',
    email: 'ali@test.com',
    phone: '01055556666',
  );

  const tPage2 = UsersPageEntity(
    users: [tUser3],
    hasMore: false,
    lastDocument: null,
  );

  setUpAll(() {
    registerFallbackValue(UserFilterType.all);
  });

  setUp(() async {
    mockGetUsersUseCase = MockGetUsersUseCase();
    mockGetUsersStatsUseCase = MockGetUsersStatsUseCase();
    sut = UsersCubit(mockGetUsersUseCase, mockGetUsersStatsUseCase);

    final fakeFirestore = FakeFirebaseFirestore();
    fakeDoc = await fakeFirestore.collection('users').doc('u_2').get();

    tPage1 = UsersPageEntity(
      users: const [tUser1, tUser2],
      hasMore: true,
      lastDocument: fakeDoc,
    );
  });

  tearDown(() => sut.close());

  group('UsersCubit', () {
    test('initial state and getters should have default values', () {
      expect(sut.state, isA<UsersInitial>());
      expect(sut.totalCount, 0);
      expect(sut.verifiedCount, 0);
      expect(sut.activeCartCount, 0);
      expect(sut.activeFilter, UserFilterType.all);
    });

    group('initUsers', () {
      blocTest<UsersCubit, UsersState>(
        'should fetch stats and users in parallel and emit [UsersLoading, UsersSuccess] with correct stats',
        setUp: () {
          when(() => mockGetUsersStatsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess(tStats));
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) => cubit.initUsers(),
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2])
              .having((s) => s.hasMore, 'hasMore', isTrue)
              .having((s) => s.totalCount, 'totalCount', 30)
              .having((s) => s.verifiedCount, 'verifiedCount', 20)
              .having((s) => s.activeCartCount, 'activeCartCount', 10),
        ],
        verify: (_) {
          expect(sut.totalCount, 30);
          expect(sut.verifiedCount, 20);
          expect(sut.activeCartCount, 10);
          verify(() => mockGetUsersStatsUseCase.call()).called(1);
          verify(
            () => mockGetUsersUseCase.call(
              limit: 15,
              filter: UserFilterType.all,
            ),
          ).called(1);
        },
      );
    });

    group('getUsersStats', () {
      test('should update stats getters when getUsersStats succeeds', () async {
        // Arrange
        when(() => mockGetUsersStatsUseCase.call())
            .thenAnswer((_) async => const NetworkSuccess(tStats));

        // Act
        await sut.getUsersStats();

        // Assert
        expect(sut.totalCount, 30);
        expect(sut.verifiedCount, 20);
        expect(sut.activeCartCount, 10);
      });

      blocTest<UsersCubit, UsersState>(
        'should emit updated UsersSuccess when state is already UsersSuccess',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(() => mockGetUsersStatsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess(tStats));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getUsers();
          await cubit.getUsersStats();
        },
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.totalCount, 'totalCount', 0),
          isA<UsersSuccess>()
              .having((s) => s.totalCount, 'totalCount', 30)
              .having((s) => s.verifiedCount, 'verifiedCount', 20)
              .having((s) => s.activeCartCount, 'activeCartCount', 10),
        ],
      );

      test('should keep existing stats when stats response is failure', () async {
        // Arrange
        when(() => mockGetUsersStatsUseCase.call())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        await sut.getUsersStats();

        // Assert
        expect(sut.totalCount, 0);
        expect(sut.verifiedCount, 0);
        expect(sut.activeCartCount, 0);
      });
    });

    group('getUsers', () {
      blocTest<UsersCubit, UsersState>(
        'should emit [UsersLoading, UsersSuccess] when getUsers succeeds',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) => cubit.getUsers(),
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2])
              .having((s) => s.hasMore, 'hasMore', isTrue)
              .having((s) => s.activeFilter, 'activeFilter', UserFilterType.all),
        ],
        verify: (_) {
          verify(
            () => mockGetUsersUseCase.call(
              limit: 15,
              filter: UserFilterType.all,
            ),
          ).called(1);
        },
      );

      blocTest<UsersCubit, UsersState>(
        'should emit [UsersLoading, UsersSuccess] with empty list when NetworkSuccess data is null',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) => cubit.getUsers(),
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', isEmpty)
              .having((s) => s.hasMore, 'hasMore', isFalse),
        ],
      );

      blocTest<UsersCubit, UsersState>(
        'should emit [UsersLoading, UsersFailure] when getUsers fails',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.getUsers(),
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersFailure>().having((s) => s.message, 'message', tErrorMessage),
        ],
      );

      blocTest<UsersCubit, UsersState>(
        'should update activeFilter when filter parameter is passed',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) => cubit.getUsers(filter: UserFilterType.verified),
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.activeFilter, 'activeFilter', UserFilterType.verified),
        ],
        verify: (_) {
          expect(sut.activeFilter, UserFilterType.verified);
          verify(
            () => mockGetUsersUseCase.call(
              limit: 15,
              filter: UserFilterType.verified,
            ),
          ).called(1);
        },
      );
    });

    group('loadMoreUsers', () {
      test('should not load more if state is not UsersSuccess', () async {
        // Act
        await sut.loadMoreUsers();

        // Assert
        verifyZeroInteractions(mockGetUsersUseCase);
      });

      blocTest<UsersCubit, UsersState>(
        'should not load more if hasMore is false',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess(tPage2)); // hasMore: false
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getUsers();
          await cubit.loadMoreUsers();
        },
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>().having((s) => s.hasMore, 'hasMore', isFalse),
        ],
        verify: (_) {
          verify(
            () => mockGetUsersUseCase.call(
              limit: 15,
              filter: UserFilterType.all,
            ),
          ).called(1);
        },
      );

      blocTest<UsersCubit, UsersState>(
        'should append users and emit [UsersSuccess(isLoadingMore: true), UsersSuccess(isLoadingMore: false)] when loadMore succeeds',
        setUp: () {
          // First page
          when(
            () => mockGetUsersUseCase.call(
              limit: 15,
              lastDocument: null,
              filter: UserFilterType.all,
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          // Second page
          when(
            () => mockGetUsersUseCase.call(
              limit: 15,
              lastDocument: fakeDoc,
              filter: UserFilterType.all,
            ),
          ).thenAnswer((_) async => const NetworkSuccess(tPage2));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getUsers();
          await cubit.loadMoreUsers();
        },
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2])
              .having((s) => s.hasMore, 'hasMore', isTrue)
              .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse),
          isA<UsersSuccess>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', isTrue),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2, tUser3])
              .having((s) => s.hasMore, 'hasMore', isFalse)
              .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse),
        ],
        verify: (_) {
          verify(
            () => mockGetUsersUseCase.call(
              limit: 15,
              lastDocument: fakeDoc,
              filter: UserFilterType.all,
            ),
          ).called(1);
        },
      );

      blocTest<UsersCubit, UsersState>(
        'should set hasMore to false when loadMore returns null data',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: 15,
              lastDocument: null,
              filter: UserFilterType.all,
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(
            () => mockGetUsersUseCase.call(
              limit: 15,
              lastDocument: fakeDoc,
              filter: UserFilterType.all,
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getUsers();
          await cubit.loadMoreUsers();
        },
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2])
              .having((s) => s.hasMore, 'hasMore', isTrue),
          isA<UsersSuccess>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', isTrue),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2])
              .having((s) => s.hasMore, 'hasMore', isFalse)
              .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse),
        ],
      );

      blocTest<UsersCubit, UsersState>(
        'should reset isLoadingMore to false when loadMore fails',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: 15,
              lastDocument: null,
              filter: UserFilterType.all,
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(
            () => mockGetUsersUseCase.call(
              limit: 15,
              lastDocument: fakeDoc,
              filter: UserFilterType.all,
            ),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getUsers();
          await cubit.loadMoreUsers();
        },
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2])
              .having((s) => s.hasMore, 'hasMore', isTrue),
          isA<UsersSuccess>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', isTrue),
          isA<UsersSuccess>()
              .having((s) => s.users, 'users', [tUser1, tUser2])
              .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse),
        ],
      );
    });

    group('setFilter', () {
      blocTest<UsersCubit, UsersState>(
        'should update filter and reload users when a new filter is selected',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) => cubit.setFilter(UserFilterType.withCart),
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>()
              .having((s) => s.activeFilter, 'activeFilter', UserFilterType.withCart),
        ],
        verify: (_) {
          expect(sut.activeFilter, UserFilterType.withCart);
          verify(
            () => mockGetUsersUseCase.call(
              limit: 15,
              filter: UserFilterType.withCart,
            ),
          ).called(1);
        },
      );

      blocTest<UsersCubit, UsersState>(
        'should do nothing if same filter is selected while state is UsersSuccess',
        setUp: () {
          when(
            () => mockGetUsersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              filter: any(named: 'filter'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getUsers(); // default is UserFilterType.all
          await cubit.setFilter(UserFilterType.all); // same filter
        },
        expect: () => [
          isA<UsersLoading>(),
          isA<UsersSuccess>(),
        ],
        verify: (_) {
          // Should only be called once by the initial getUsers()
          verify(
            () => mockGetUsersUseCase.call(
              limit: 15,
              filter: UserFilterType.all,
            ),
          ).called(1);
        },
      );
    });
  });
}
