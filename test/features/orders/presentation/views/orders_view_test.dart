import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_error_view.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/orders_view.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/custom_order_item.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_empty_state.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_skeleton_list.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_stats_header.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_stats_header_skeleton.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockOrdersCubit extends MockCubit<OrdersState> implements OrdersCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
    registerFallbackValue(const OrdersInitial());
  });

  late MockOrdersCubit mockOrdersCubit;
  late StreamController<OrdersState> stateController;

  const tOrder1 = OrderEntity(
    docId: 'doc_1',
    orderId: 5001,
    totalPrice: 200.0,
    status: OrderStatus.pending,
  );

  const tOrder2 = OrderEntity(
    docId: 'doc_2',
    orderId: 5002,
    totalPrice: 350.0,
    status: OrderStatus.delivered,
  );

  const tStats = OrdersStatsEntity(
    totalCount: 20,
    pendingCount: 8,
    processingCount: 4,
    shippedCount: 2,
    deliveredCount: 5,
    cancelledCount: 1,
  );

  setUp(() {
    mockOrdersCubit = MockOrdersCubit();
    stateController = StreamController<OrdersState>.broadcast();

    when(() => mockOrdersCubit.state).thenReturn(const OrdersInitial());
    when(() => mockOrdersCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockOrdersCubit.initOrders()).thenAnswer((_) async {});
    when(() => mockOrdersCubit.loadMoreOrders()).thenAnswer((_) async {});
    when(() => mockOrdersCubit.setFilter(any())).thenAnswer((_) async {});
    when(() => mockOrdersCubit.currentOrders).thenReturn([]);
    when(() => mockOrdersCubit.stats).thenReturn(const OrdersStatsEntity());
    when(() => mockOrdersCubit.activeFilter).thenReturn(null);
    when(() => mockOrdersCubit.hasMore).thenReturn(false);
    when(() => mockOrdersCubit.isLoadingMore).thenReturn(false);

    if (getIt.isRegistered<OrdersCubit>()) {
      getIt.unregister<OrdersCubit>();
    }
    getIt.registerFactory<OrdersCubit>(() => mockOrdersCubit);
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<OrdersCubit>()) {
      getIt.unregister<OrdersCubit>();
    }
  });

  group('OrdersView Widget Tests', () {
    testWidgets(
      'should render CustomAppBar, search field, and call initOrders on init',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersView()),
        );

        // Assert
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(AppStrings.orders), findsOneWidget);
        expect(find.byType(SearchTextField), findsOneWidget);
        expect(find.byType(CustomArrowBack), findsOneWidget);
        verify(() => mockOrdersCubit.initOrders()).called(1);
      },
    );

    testWidgets('should pop view when back arrow is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(child: const OrdersView()),
      );

      // Act
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OrdersView), findsNothing);
    });

    testWidgets(
      'should render skeleton header and skeleton list on initial loading',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersCubit.state)
            .thenReturn(const OrdersLoading(OrderState.getOrders));
        when(() => mockOrdersCubit.stats).thenReturn(const OrdersStatsEntity());

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersView()),
        );

        // Assert
        expect(find.byType(OrdersStatsHeaderSkeleton), findsOneWidget);
        expect(find.byType(OrdersSkeletonList), findsOneWidget);
      },
    );

    testWidgets('should render CustomErrorView when initial fetch fails', (
      WidgetTester tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load orders';
      when(() => mockOrdersCubit.state).thenReturn(
        const OrdersFailure(
          message: errorMessage,
          orderState: OrderState.getOrders,
        ),
      );
      when(() => mockOrdersCubit.currentOrders).thenReturn([]);

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const OrdersView()),
      );

      // Assert
      expect(find.byType(CustomErrorView), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);

      // Act: Tap retry
      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();

      // Assert: called initOrders again
      verify(() => mockOrdersCubit.initOrders()).called(2);
    });

    testWidgets(
      'should render OrdersEmptyState when orders list is empty in success state',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersCubit.state).thenReturn(
          const OrdersSuccess(
            orders: [],
            stats: tStats,
            orderState: OrderState.getOrders,
          ),
        );
        when(() => mockOrdersCubit.stats).thenReturn(tStats);

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersView()),
        );

        // Assert
        expect(find.byType(OrdersStatsHeader), findsOneWidget);
        expect(find.byType(OrdersEmptyState), findsOneWidget);
      },
    );

    testWidgets(
      'should render orders list items when orders exist in success state',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersCubit.state).thenReturn(
          const OrdersSuccess(
            orders: [tOrder1, tOrder2],
            stats: tStats,
            orderState: OrderState.getOrders,
          ),
        );
        when(() => mockOrdersCubit.currentOrders)
            .thenReturn([tOrder1, tOrder2]);
        when(() => mockOrdersCubit.stats).thenReturn(tStats);

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersView()),
        );

        // Assert
        expect(find.byType(OrdersStatsHeader), findsOneWidget);
        expect(find.byType(CustomOrderItem), findsNWidgets(2));
        expect(find.byKey(const ValueKey('doc_1')), findsOneWidget);
        expect(find.byKey(const ValueKey('doc_2')), findsOneWidget);
      },
    );

    testWidgets(
      'should show CupertinoActivityIndicator loading footer when isLoadingMore is true',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersCubit.state).thenReturn(
          const OrdersSuccess(
            orders: [tOrder1],
            stats: tStats,
            isLoadingMore: true,
          ),
        );
        when(() => mockOrdersCubit.currentOrders).thenReturn([tOrder1]);
        when(() => mockOrdersCubit.stats).thenReturn(tStats);

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersView()),
        );

        // Assert
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'should navigate to ordersSearchView when search text field is tapped',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockOrdersCubit.state)
            .thenReturn(const OrdersSuccess(orders: [tOrder1], stats: tStats));
        when(() => mockOrdersCubit.currentOrders).thenReturn([tOrder1]);
        when(() => mockOrdersCubit.stats).thenReturn(tStats);

        bool navigated = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrdersView(),
            onGenerateRoute: (settings) {
              if (settings.name == Routes.ordersSearchView) {
                navigated = true;
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const Scaffold(body: Text('Search View')),
                );
              }
              return null;
            },
          ),
        );

        // Act: Tap search bar
        await tester.tap(find.byType(SearchTextField));
        await tester.pumpAndSettle();

        // Assert
        expect(navigated, isTrue);
      },
    );
  });
}
