import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/dashboard_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/search_users_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/users_search_cubit/users_search_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchUsersUseCase extends Mock implements SearchUsersUseCase {}

void main() {
  late MockSearchUsersUseCase mockSearchUsersUseCase;
  late UsersSearchCubit sut;

  const tErrorMessage = 'Failed to search users';
  const tFailure = ServerFailure(error: tErrorMessage);

  const tUser = DashboardUserEntity(
    uid: 'u_100',
    name: 'Karim',
    email: 'karim@test.com',
    phone: '01012345678',
  );

  setUpAll(() {
    registerFallbackValue(UserSearchBy.name);
  });

  setUp(() {
    mockSearchUsersUseCase = MockSearchUsersUseCase();
    sut = UsersSearchCubit(mockSearchUsersUseCase);
  });

  tearDown(() => sut.close());

  group('UsersSearchCubit', () {
    test('initial state and getters should have default values', () {
      expect(sut.state, isA<UsersSearchInitial>());
      expect(sut.state.searchBy, UserSearchBy.name);
      expect(sut.currentSearchBy, UserSearchBy.name);
      expect(sut.currentQuery, isEmpty);
    });

    group('searchUsers', () {
      blocTest<UsersSearchCubit, UsersSearchState>(
        'should emit UsersSearchInitial and not call use case when query is empty',
        build: () => sut,
        act: (cubit) => cubit.searchUsers(''),
        expect: () => [
          isA<UsersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.name,
          ),
        ],
        verify: (_) {
          expect(sut.currentQuery, '');
          verifyZeroInteractions(mockSearchUsersUseCase);
        },
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should emit UsersSearchInitial and not call use case when query is whitespace only',
        build: () => sut,
        act: (cubit) => cubit.searchUsers('    '),
        expect: () => [
          isA<UsersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.name,
          ),
        ],
        verify: (_) {
          expect(sut.currentQuery, '');
          verifyZeroInteractions(mockSearchUsersUseCase);
        },
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should emit [UsersSearchLoading, UsersSearchSuccess] when search succeeds by name',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tUser]));
        },
        build: () => sut,
        act: (cubit) => cubit.searchUsers('Karim'),
        expect: () => [
          isA<UsersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.name,
          ),
          isA<UsersSearchSuccess>()
              .having((s) => s.users, 'users', [tUser])
              .having((s) => s.query, 'query', 'Karim')
              .having((s) => s.searchBy, 'searchBy', UserSearchBy.name),
        ],
        verify: (_) {
          expect(sut.currentQuery, 'Karim');
          verify(
            () => mockSearchUsersUseCase.call(
              query: 'Karim',
              searchBy: UserSearchBy.name,
            ),
          ).called(1);
        },
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should auto-detect email when query contains @ and switch searchBy to email',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tUser]));
        },
        build: () => sut,
        act: (cubit) => cubit.searchUsers('karim@test.com'),
        expect: () => [
          isA<UsersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.email,
          ),
          isA<UsersSearchSuccess>()
              .having((s) => s.users, 'users', [tUser])
              .having((s) => s.query, 'query', 'karim@test.com')
              .having((s) => s.searchBy, 'searchBy', UserSearchBy.email),
        ],
        verify: (_) {
          expect(sut.currentSearchBy, UserSearchBy.email);
          expect(sut.currentQuery, 'karim@test.com');
          verify(
            () => mockSearchUsersUseCase.call(
              query: 'karim@test.com',
              searchBy: UserSearchBy.email,
            ),
          ).called(1);
        },
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should auto-detect phone when query matches phone regex and switch searchBy to phone',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tUser]));
        },
        build: () => sut,
        act: (cubit) => cubit.searchUsers('01012345678'),
        expect: () => [
          isA<UsersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.phone,
          ),
          isA<UsersSearchSuccess>()
              .having((s) => s.users, 'users', [tUser])
              .having((s) => s.query, 'query', '01012345678')
              .having((s) => s.searchBy, 'searchBy', UserSearchBy.phone),
        ],
        verify: (_) {
          expect(sut.currentSearchBy, UserSearchBy.phone);
          expect(sut.currentQuery, '01012345678');
          verify(
            () => mockSearchUsersUseCase.call(
              query: '01012345678',
              searchBy: UserSearchBy.phone,
            ),
          ).called(1);
        },
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should auto-detect phone with leading plus symbol (+201012345678)',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tUser]));
        },
        build: () => sut,
        act: (cubit) => cubit.searchUsers('+201012345678'),
        expect: () => [
          isA<UsersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.phone,
          ),
          isA<UsersSearchSuccess>()
              .having((s) => s.searchBy, 'searchBy', UserSearchBy.phone),
        ],
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should use explicitly passed searchBy parameter',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tUser]));
        },
        build: () => sut,
        act: (cubit) => cubit.searchUsers('Ali', searchBy: UserSearchBy.name),
        expect: () => [
          isA<UsersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.name,
          ),
          isA<UsersSearchSuccess>(),
        ],
        verify: (_) {
          expect(sut.currentSearchBy, UserSearchBy.name);
          verify(
            () => mockSearchUsersUseCase.call(
              query: 'Ali',
              searchBy: UserSearchBy.name,
            ),
          ).called(1);
        },
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should emit UsersSearchSuccess with empty list when NetworkSuccess data is null',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) => cubit.searchUsers('NonExistent'),
        expect: () => [
          isA<UsersSearchLoading>(),
          isA<UsersSearchSuccess>().having((s) => s.users, 'users', isEmpty),
        ],
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should emit [UsersSearchLoading, UsersSearchFailure] when search fails',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.searchUsers('Karim'),
        expect: () => [
          isA<UsersSearchLoading>(),
          isA<UsersSearchFailure>()
              .having((s) => s.message, 'message', tErrorMessage)
              .having((s) => s.searchBy, 'searchBy', UserSearchBy.name),
        ],
      );
    });

    group('setSearchBy', () {
      blocTest<UsersSearchCubit, UsersSearchState>(
        'should update searchBy, clear query, and emit UsersSearchInitial when changed',
        build: () => sut,
        act: (cubit) => cubit.setSearchBy(UserSearchBy.email),
        expect: () => [
          isA<UsersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.email,
          ),
        ],
        verify: (_) {
          expect(sut.currentSearchBy, UserSearchBy.email);
          expect(sut.currentQuery, isEmpty);
        },
      );

      blocTest<UsersSearchCubit, UsersSearchState>(
        'should do nothing when passing the already active searchBy',
        build: () => sut,
        act: (cubit) => cubit.setSearchBy(UserSearchBy.name), // default is name
        expect: () => [],
        verify: (_) {
          expect(sut.currentSearchBy, UserSearchBy.name);
        },
      );
    });

    group('clearSearch', () {
      blocTest<UsersSearchCubit, UsersSearchState>(
        'should reset query to empty and emit UsersSearchInitial with currentSearchBy',
        setUp: () {
          when(
            () => mockSearchUsersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tUser]));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.searchUsers('karim@test.com'); // auto-sets searchBy to email
          cubit.clearSearch();
        },
        expect: () => [
          isA<UsersSearchLoading>(),
          isA<UsersSearchSuccess>(),
          isA<UsersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            UserSearchBy.email,
          ),
        ],
        verify: (_) {
          expect(sut.currentQuery, isEmpty);
          expect(sut.currentSearchBy, UserSearchBy.email);
        },
      );
    });
  });
}
