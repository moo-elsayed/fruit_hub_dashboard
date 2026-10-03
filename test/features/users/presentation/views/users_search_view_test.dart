import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/app_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/users_search_cubit/users_search_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/views/users_search_view.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_search_filter_chips.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_search_results_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_skeleton_list.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_status_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockUsersSearchCubit extends MockCubit<UsersSearchState>
    implements UsersSearchCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(UserSearchBy.name);
    registerFallbackValue(const UsersSearchInitial());
  });

  late MockUsersSearchCubit mockUsersSearchCubit;
  late StreamController<UsersSearchState> stateController;

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
    mockUsersSearchCubit = MockUsersSearchCubit();
    stateController = StreamController<UsersSearchState>.broadcast();

    when(() => mockUsersSearchCubit.state).thenReturn(const UsersSearchInitial());
    when(() => mockUsersSearchCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockUsersSearchCubit.currentSearchBy).thenReturn(UserSearchBy.name);
    when(
      () => mockUsersSearchCubit.searchUsers(
        any(),
        searchBy: any(named: 'searchBy'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockUsersSearchCubit.setSearchBy(any())).thenAnswer((_) {});
    when(() => mockUsersSearchCubit.clearSearch()).thenAnswer((_) {});

    if (getIt.isRegistered<UsersSearchCubit>()) {
      getIt.unregister<UsersSearchCubit>();
    }
    getIt.registerFactory<UsersSearchCubit>(() => mockUsersSearchCubit);
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<UsersSearchCubit>()) {
      getIt.unregister<UsersSearchCubit>();
    }
  });

  group('UsersSearchView Widget Tests', () {
    testWidgets(
      'should render CustomAppBar, SearchTextField, and UsersSearchFilterChips on initial build',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(AppStrings.search), findsOneWidget);
        expect(find.byType(SearchTextField), findsOneWidget);
        expect(find.byType(UsersSearchFilterChips), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersStatusView with typeToSearchUsers message when state is UsersSearchInitial',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersSearchCubit.state).thenReturn(
          const UsersSearchInitial(),
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(UsersStatusView), findsOneWidget);
        expect(find.text(AppStrings.typeToSearchUsers), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(UsersStatusView),
            matching: find.byIcon(Icons.search_rounded),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should render UsersSkeletonList when state is UsersSearchLoading',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersSearchCubit.state).thenReturn(
          const UsersSearchLoading(searchBy: UserSearchBy.name),
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(UsersSkeletonList), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersStatusView with error message when state is UsersSearchFailure',
      (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Search failed';
        when(() => mockUsersSearchCubit.state).thenReturn(
          const UsersSearchFailure(errorMessage, searchBy: UserSearchBy.name),
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(UsersStatusView), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersStatusView with noSearchResultsFound when UsersSearchSuccess has empty users',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersSearchCubit.state).thenReturn(
          const UsersSearchSuccess(
            users: [],
            query: 'xyz',
            searchBy: UserSearchBy.name,
          ),
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(UsersStatusView), findsOneWidget);
        expect(find.text(AppStrings.noSearchResultsFound), findsOneWidget);
        expect(find.byIcon(Icons.person_off_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'should render UsersSearchResultsList when UsersSearchSuccess has users',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUsersSearchCubit.state).thenReturn(
          const UsersSearchSuccess(
            users: [tUser1, tUser2],
            query: 'ahmed',
            searchBy: UserSearchBy.name,
          ),
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(UsersSearchResultsList), findsOneWidget);
        expect(find.text(tUser1.name), findsOneWidget);
        expect(find.text(tUser2.name), findsOneWidget);
      },
    );

    testWidgets(
      'should pop view when back arrow is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UsersSearchView()),
                ),
                child: const Text('Open Search'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Open UsersSearchView
        await tester.tap(find.text('Open Search'));
        await tester.pumpAndSettle();
        expect(find.byType(UsersSearchView), findsOneWidget);

        // Act: tap back arrow
        await tester.tap(find.byType(CustomArrowBack));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(UsersSearchView), findsNothing);
        expect(find.text('Open Search'), findsOneWidget);
      },
    );

    testWidgets(
      'should trigger searchUsers after debounce when query is typed',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Act
        await tester.enterText(find.byType(SearchTextField), 'Kareem');
        await tester.pump(const Duration(milliseconds: 200));

        // Verify not yet called before debounce
        verifyNever(() => mockUsersSearchCubit.searchUsers('Kareem'));

        // Advance timer past debounce threshold (350ms)
        await tester.pump(const Duration(milliseconds: 200));

        // Assert
        verify(() => mockUsersSearchCubit.searchUsers('Kareem')).called(1);
      },
    );

    testWidgets(
      'should call clearSearch when query becomes empty',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Act: enter text first, then clear it
        await tester.enterText(find.byType(SearchTextField), 'Kareem');
        await tester.pump();
        await tester.enterText(find.byType(SearchTextField), '');
        await tester.pump();

        // Assert
        verify(() => mockUsersSearchCubit.clearSearch()).called(1);
      },
    );

    testWidgets(
      'should call clearSearch when clear button in search field is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Act: enter text to display clear icon
        await tester.enterText(find.byType(SearchTextField), 'Kareem');
        await tester.pump();

        // Tap clear button
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pump();

        // Assert
        verify(() => mockUsersSearchCubit.clearSearch()).called(greaterThanOrEqualTo(1));
      },
    );

    testWidgets(
      'should call setSearchBy when a filter chip is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Act
        await tester.tap(find.text(AppStrings.searchByEmail));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockUsersSearchCubit.setSearchBy(UserSearchBy.email)).called(1);
      },
    );
  });
}
