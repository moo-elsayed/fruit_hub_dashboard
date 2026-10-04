import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/app_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/users_cubit/users_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/views/users_view.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_card_item.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_empty_state.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_skeleton_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_stats_header.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_stats_header_skeleton.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_status_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockUsersCubit extends MockCubit<UsersState> implements UsersCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(UserFilterType.all);
  });

  late MockUsersCubit mockUsersCubit;
  late StreamController<UsersState> stateController;

  const tUser1 = AppUserEntity(
    uid: 'user_1',
    name: 'Kareem Ahmed',
    email: 'kareem@example.com',
    phone: '01011112222',
    isVerified: true,
  );

  const tUser2 = AppUserEntity(
    uid: 'user_2',
    name: 'Mona Ali',
    email: 'mona@example.com',
    phone: '01033334444',
    isVerified: false,
  );

  setUp(() {
    mockUsersCubit = MockUsersCubit();
    stateController = StreamController<UsersState>.broadcast();

    when(() => mockUsersCubit.state).thenReturn(UsersInitial());
    when(() => mockUsersCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockUsersCubit.initUsers()).thenAnswer((_) async {});
    when(() => mockUsersCubit.loadMoreUsers()).thenAnswer((_) async {});
    when(() => mockUsersCubit.setFilter(any())).thenAnswer((_) async {});
    when(() => mockUsersCubit.totalCount).thenReturn(0);
    when(() => mockUsersCubit.verifiedCount).thenReturn(0);
    when(() => mockUsersCubit.activeCartCount).thenReturn(0);
    when(() => mockUsersCubit.activeFilter).thenReturn(UserFilterType.all);

    if (getIt.isRegistered<UsersCubit>()) {
      getIt.unregister<UsersCubit>();
    }
    getIt.registerFactory<UsersCubit>(() => mockUsersCubit);
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<UsersCubit>()) {
      getIt.unregister<UsersCubit>();
    }
  });

  group('UsersView Widget Tests', () {
    testWidgets(
      'should render CustomAppBar, search text field, and call initUsers on init',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersView()),
        );

        // Assert
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(AppStrings.users), findsOneWidget);
        expect(find.byType(SearchTextField), findsOneWidget);
        expect(find.byType(CustomArrowBack), findsOneWidget);
        verify(() => mockUsersCubit.initUsers()).called(1);
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
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const UsersView())),
              child: const Text('Open Users'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open UsersView
      await tester.tap(find.text('Open Users'));
      await tester.pumpAndSettle();
      expect(find.byType(UsersView), findsOneWidget);

      // Act: tap back arrow
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(UsersView), findsNothing);
      expect(find.text('Open Users'), findsOneWidget);
    });

    testWidgets(
      'should render UsersStatsHeaderSkeleton when state is UsersLoading and totalCount is 0',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersCubit.state).thenReturn(UsersLoading());
        when(() => mockUsersCubit.totalCount).thenReturn(0);

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersView()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(UsersStatsHeaderSkeleton), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersStatsHeader and trigger setFilter when tab is tapped',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersCubit.state).thenReturn(
          const UsersSuccess(
            users: [tUser1],
            totalCount: 42,
            verifiedCount: 20,
            activeCartCount: 8,
          ),
        );
        when(() => mockUsersCubit.totalCount).thenReturn(42);

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersView()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(UsersStatsHeader), findsOneWidget);
        expect(find.text('42'), findsOneWidget);

        // Act: tap verified filter
        await tester.tap(find.text(AppStrings.verifiedUsers));
        await tester.pump();

        // Assert
        verify(() => mockUsersCubit.setFilter(UserFilterType.verified))
            .called(1);
      },
    );

    testWidgets(
      'should navigate to usersSearchView when SearchTextField is tapped',
      (WidgetTester tester) async {
        // Arrange
        String? currentRoute;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UsersView(),
            routes: {
              Routes.usersSearchView: (_) {
                currentRoute = Routes.usersSearchView;
                return const Scaffold(body: Text('Search Screen'));
              },
            },
          ),
        );
        await tester.pump();

        // Act
        await tester.tap(find.byType(SearchTextField));
        await tester.pumpAndSettle();

        // Assert
        expect(currentRoute, equals(Routes.usersSearchView));
        expect(find.text('Search Screen'), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersSkeletonList when body state is UsersLoading',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersCubit.state).thenReturn(UsersLoading());

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersView()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(UsersSkeletonList), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersStatusView with error message when state is UsersFailure',
      (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Failed to load users';
        when(() => mockUsersCubit.state)
            .thenReturn(const UsersFailure(errorMessage));

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersView()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(UsersStatusView), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersEmptyState when users list is empty in UsersSuccess',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersCubit.state)
            .thenReturn(const UsersSuccess(users: []));

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersView()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(UsersEmptyState), findsOneWidget);
      },
    );

    testWidgets(
      'should render list of UserCardItem and navigate to userDetailsView on tap',
      (WidgetTester tester) async {
        // Arrange
        AppUserEntity? passedUser;
        when(() => mockUsersCubit.state)
            .thenReturn(const UsersSuccess(users: [tUser1, tUser2]));

        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UsersView(),
            onGenerateRoute: (settings) {
              if (settings.name == Routes.userDetailsView) {
                passedUser = settings.arguments as AppUserEntity?;
                return MaterialPageRoute(
                  builder: (_) => const Scaffold(body: Text('User Details')),
                );
              }
              return null;
            },
          ),
        );
        await tester.pump();

        // Assert list items
        expect(find.byType(UserCardItem), findsNWidgets(2));
        expect(find.text(tUser1.name), findsOneWidget);
        expect(find.text(tUser2.name), findsOneWidget);

        // Act: tap first user card
        await tester.tap(find.text(tUser1.name));
        await tester.pumpAndSettle();

        // Assert navigation
        expect(find.text('User Details'), findsOneWidget);
        expect(passedUser, equals(tUser1));
      },
    );

    testWidgets(
      'should render loading indicator at footer when isLoadingMore is true',
      (WidgetTester tester) async {
        // Arrange
        when(
          () => mockUsersCubit.state,
        ).thenReturn(const UsersSuccess(users: [tUser1], isLoadingMore: true));

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersView()),
        );
        await tester.pump();

        // Assert
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      },
    );

    testWidgets('should call initUsers on pull to refresh', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockUsersCubit.state)
          .thenReturn(const UsersSuccess(users: [tUser1, tUser2]));

      await tester.pumpWidget(createWidgetForTesting(child: const UsersView()));
      await tester.pump();

      // Clear the initial invocation count
      clearInteractions(mockUsersCubit);

      // Act: pull to refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockUsersCubit.initUsers()).called(1);
    });
  });
}
