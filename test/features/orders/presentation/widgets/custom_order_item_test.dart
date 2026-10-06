import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_price_text.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/payment_option_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_stats_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/custom_order_item.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_card_header.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_customer_details.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_financial_summary.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_header_badge.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_products_list.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_summary_bar.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}

class MockGetOrdersStatsUseCase extends Mock implements GetOrdersStatsUseCase {}

class MockUpdateOrderStatusUseCase extends Mock
    implements UpdateOrderStatusUseCase {}

void main() {
  group('CustomOrderItem Widget Tests', () {
    late MockGetOrdersUseCase mockGetOrdersUseCase;
    late MockGetOrdersStatsUseCase mockGetOrdersStatsUseCase;
    late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;
    late OrdersCubit mockCubit;

    const tOrder = OrderEntity(
      docId: 'doc_123',
      orderId: 8801,
      totalPrice: 280.0,
      status: OrderStatus.pending,
      date: '2026-10-06T15:30:00Z',
      address: AddressEntity(
        name: 'Hassan Ali',
        phone: '01012345678',
        city: 'Cairo',
        streetName: 'Nasr City',
      ),
      paymentOption: PaymentOptionEntity(
        type: PaymentMethodType.cash,
        shippingCost: 30.0,
      ),
      products: [
        OrderItemEntity(name: 'Apples', code: 'APP', price: 50.0, quantity: 5),
      ],
    );

    setUpAll(() {
      registerFallbackValue(OrderStatus.pending);
    });

    setUp(() {
      mockGetOrdersUseCase = MockGetOrdersUseCase();
      mockGetOrdersStatsUseCase = MockGetOrdersStatsUseCase();
      mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();

      mockCubit = OrdersCubit(
        mockGetOrdersUseCase,
        mockGetOrdersStatsUseCase,
        mockUpdateOrderStatusUseCase,
      );
    });

    tearDown(() => mockCubit.close());

    testWidgets(
      'should render OrderCardHeader and OrderSummaryBar initially collapsed',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const SingleChildScrollView(
              child: CustomOrderItem(orderEntity: tOrder),
            ),
          ),
        );

        // Assert
        expect(find.byType(OrderCardHeader), findsOneWidget);
        expect(find.byType(OrderSummaryBar), findsOneWidget);
        expect(find.text('${AppStrings.orderNumber} #8801'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(OrderSummaryBar),
            matching: find.byType(CustomPriceText),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should expand and reveal customer details, products list, and financial summary on toggle',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const SingleChildScrollView(
              child: CustomOrderItem(orderEntity: tOrder),
            ),
          ),
        );

        // Act: Tap on toggle button in OrderSummaryBar
        await tester.tap(find.text(AppStrings.viewDetails));
        await tester.pumpAndSettle();

        // Assert expanded components
        expect(find.byType(OrderCustomerDetails), findsOneWidget);
        expect(find.text('Hassan Ali'), findsOneWidget);
        expect(find.byType(OrderProductsList), findsOneWidget);
        expect(find.byType(OrderFinancialSummary), findsOneWidget);
        expect(find.text(AppStrings.hideDetails), findsOneWidget);

        // Act: Tap hideDetails to collapse again
        await tester.tap(find.text(AppStrings.hideDetails));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.viewDetails), findsOneWidget);
      },
    );

    testWidgets(
      'should open update status bottom sheet when status badge is tapped and cubit is provided',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockUpdateOrderStatusUseCase.call(any(), any()))
            .thenAnswer((_) async => const NetworkSuccess(null));
        when(() => mockGetOrdersStatsUseCase.call())
            .thenAnswer((_) async => const NetworkSuccess(OrdersStatsEntity()));

        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<OrdersCubit>.value(
              value: mockCubit,
              child: const SingleChildScrollView(
                child: CustomOrderItem(orderEntity: tOrder),
              ),
            ),
          ),
        );

        // Act: Tap status badge
        await tester.tap(find.byType(OrderHeaderBadge));
        await tester.pumpAndSettle();

        // Assert bottom sheet opens
        expect(find.text(AppStrings.updateOrderStatus), findsOneWidget);
        expect(find.text(OrderStatus.delivered.getName), findsOneWidget);
        expect(find.text(OrderStatus.cancelled.getName), findsOneWidget);
      },
    );
  });
}
