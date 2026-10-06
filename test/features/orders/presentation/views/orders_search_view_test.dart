import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_search_cubit/orders_search_cubit.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/orders_search_view.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_search_filter_chips.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_search_results_list.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_skeleton_list.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_status_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockOrdersSearchCubit extends MockCubit<OrdersSearchState>
    implements OrdersSearchCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(OrderSearchBy.orderId);
    registerFallbackValue(const OrdersSearchInitial());
  });

  late MockOrdersSearchCubit mockOrdersSearchCubit;
  late StreamController<OrdersSearchState> stateController;

  const tOrder1 = OrderEntity(
    docId: 'doc_1',
    orderId: 7001,
    totalPrice: 250.0,
    status: OrderStatus.pending,
  );

  const tOrder2 = OrderEntity(
    docId: 'doc_2',
    orderId: 7002,
    totalPrice: 400.0,
    status: OrderStatus.delivered,
  );

  setUp(() {
    mockOrdersSearchCubit = MockOrdersSearchCubit();
    stateController = StreamController<OrdersSearchState>.broadcast();

    when(() => mockOrdersSearchCubit.state)
        .thenReturn(const OrdersSearchInitial());
    when(() => mockOrdersSearchCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockOrdersSearchCubit.currentSearchBy)
        .thenReturn(OrderSearchBy.orderId);
    when(
      () => mockOrdersSearchCubit.searchOrders(
        any(),
        searchBy: any(named: 'searchBy'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockOrdersSearchCubit.setSearchBy(any())).thenAnswer((_) {});
    when(() => mockOrdersSearchCubit.clearSearch()).thenAnswer((_) {});

    if (getIt.isRegistered<OrdersSearchCubit>()) {
      getIt.unregister<OrdersSearchCubit>();
    }
    getIt.registerFactory<OrdersSearchCubit>(() => mockOrdersSearchCubit);
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<OrdersSearchCubit>()) {
      getIt.unregister<OrdersSearchCubit>();
    }
  });

  group('OrdersSearchView Widget Tests', () {
    testWidgets(
      'should render CustomAppBar, SearchTextField, and OrdersSearchFilterChips on initial build',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(AppStrings.search), findsOneWidget);
        expect(find.byType(SearchTextField), findsOneWidget);
        expect(find.byType(OrdersSearchFilterChips), findsOneWidget);
        expect(find.byType(OrdersStatusView), findsOneWidget);
        expect(find.text(AppStrings.typeToSearchOrders), findsOneWidget);
      },
    );

    testWidgets('should pop view when back arrow is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(child: const OrdersSearchView()),
      );
      await tester.pump(const Duration(milliseconds: 400));

      // Act
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OrdersSearchView), findsNothing);
    });

    testWidgets(
      'should trigger searchOrders after debounce duration when user types in search field',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Act
        await tester.enterText(find.byType(SearchTextField), '7001');
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        verify(() => mockOrdersSearchCubit.searchOrders('7001')).called(1);
      },
    );

    testWidgets(
      'should render OrdersSkeletonList when state is OrdersSearchLoading',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersSearchCubit.state)
            .thenReturn(const OrdersSearchLoading());

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(OrdersSkeletonList), findsOneWidget);
      },
    );

    testWidgets(
      'should render noSearchResultsFound when OrdersSearchSuccess has empty orders',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersSearchCubit.state).thenReturn(
          const OrdersSearchSuccess(
            orders: [],
            query: '9999',
            searchBy: OrderSearchBy.orderId,
          ),
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(OrdersStatusView), findsOneWidget);
        expect(find.text(AppStrings.noSearchResultsFound), findsOneWidget);
        expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'should render OrdersSearchResultsList when OrdersSearchSuccess contains orders',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersSearchCubit.state).thenReturn(
          const OrdersSearchSuccess(
            orders: [tOrder1, tOrder2],
            query: '700',
            searchBy: OrderSearchBy.orderId,
          ),
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(OrdersSearchResultsList), findsOneWidget);
        expect(find.byKey(const ValueKey('doc_1')), findsOneWidget);
        expect(find.byKey(const ValueKey('doc_2')), findsOneWidget);
      },
    );

    testWidgets(
      'should render error OrdersStatusView when state is OrdersSearchFailure',
      (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Network connection failed';
        when(() => mockOrdersSearchCubit.state)
            .thenReturn(const OrdersSearchFailure(errorMessage));

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersSearchView()),
        );
        await tester.pump(const Duration(milliseconds: 400));

        // Assert
        expect(find.byType(OrdersStatusView), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
      },
    );

    testWidgets('should call setSearchBy when a filter chip is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(child: const OrdersSearchView()),
      );
      await tester.pump(const Duration(milliseconds: 400));

      // Act
      await tester.scrollUntilVisible(
        find.text(OrderSearchBy.customerName.label),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(OrderSearchBy.customerName.label));
      await tester.pump();

      // Assert
      verify(
        () => mockOrdersSearchCubit.setSearchBy(OrderSearchBy.customerName),
      ).called(1);
    });
  });
}
