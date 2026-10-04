import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_error_view.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/core/widgets/header_action_button.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/views/products_view.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/custom_product_item.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/products_empty_state.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/products_grid_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockProductsCubit extends MockCubit<ProductsState>
    implements ProductsCubit {}

void main() {
  late MockProductsCubit mockProductsCubit;
  late StreamController<ProductsState> stateController;

  const tFruit1 = FruitEntity(
    name: 'Strawberry',
    code: 'STR100',
    price: 35.0,
    isOrganic: true,
  );
  const tFruit2 = FruitEntity(
    name: 'Watermelon',
    code: 'WAT200',
    price: 25.0,
    isFeatured: true,
  );

  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  setUp(() {
    mockProductsCubit = MockProductsCubit();
    stateController = StreamController<ProductsState>.broadcast();

    when(() => mockProductsCubit.state).thenReturn(ProductsLoading());
    when(() => mockProductsCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(
      () => mockProductsCubit.getProducts(
        needLoading: any(named: 'needLoading'),
        newItemAdded: any(named: 'newItemAdded'),
        itemRemoved: any(named: 'itemRemoved'),
        itemUpdated: any(named: 'itemUpdated'),
      ),
    ).thenAnswer((_) async {});

    if (getIt.isRegistered<ProductsCubit>()) {
      getIt.unregister<ProductsCubit>();
    }
    getIt.registerFactory<ProductsCubit>(() => mockProductsCubit);
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<ProductsCubit>()) {
      getIt.unregister<ProductsCubit>();
    }
  });

  Widget buildTestWidget({
    NavigatorObserver? navigatorObserver,
    Map<String, WidgetBuilder>? routes,
  }) => createWidgetForTesting(
    navigatorObserver: navigatorObserver,
    routes: routes,
    withToastification: true,
    child: const ProductsView(),
  );

  group('ProductsView Widget Tests', () {
    testWidgets('should render skeleton loader and call getProducts on init', (
      WidgetTester tester,
    ) async {
      setPhoneViewport(tester);
      // Arrange
      when(() => mockProductsCubit.state).thenReturn(ProductsLoading());

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      verify(() => mockProductsCubit.getProducts()).called(1);
      expect(find.byType(ProductsGridView), findsOneWidget);
      expect(find.byType(CustomProductItem), findsNWidgets(4));
    });

    testWidgets(
      'should render ProductsEmptyState when products list is empty',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        when(() => mockProductsCubit.state)
            .thenReturn(ProductsSuccess(products: []));

        // Act
        await tester.pumpWidget(buildTestWidget());

        // Assert
        expect(find.byType(ProductsEmptyState), findsOneWidget);
        expect(find.text(AppStrings.noProductsYet), findsOneWidget);
        expect(find.byType(ProductsGridView), findsNothing);
      },
    );

    testWidgets(
      'should render ProductsGridView with items when products list is non-empty',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        when(() => mockProductsCubit.state)
            .thenReturn(ProductsSuccess(products: [tFruit1, tFruit2]));

        // Act
        await tester.pumpWidget(buildTestWidget());

        // Assert
        expect(find.byType(ProductsGridView), findsOneWidget);
        expect(find.byType(CustomProductItem), findsNWidgets(2));
        expect(find.text('Strawberry'), findsOneWidget);
        expect(find.text('Watermelon'), findsOneWidget);
      },
    );

    testWidgets(
      'should render CustomErrorView when failure occurs and trigger retry',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        when(() => mockProductsCubit.state)
            .thenReturn(ProductsFailure('Failed to load products'));

        // Act
        await tester.pumpWidget(buildTestWidget());

        // Assert error view is rendered
        expect(find.byType(CustomErrorView), findsOneWidget);
        expect(find.text(AppStrings.somethingWentWrong), findsOneWidget);

        // Act - Tap retry button
        final retryButton = find.widgetWithText(
          CustomMaterialButton,
          AppStrings.retry,
        );
        expect(retryButton, findsOneWidget);
        await tester.tap(retryButton);
        await tester.pump();

        // Assert getProducts was called again for retry
        verify(() => mockProductsCubit.getProducts()).called(2);
      },
    );

    testWidgets(
      'should navigate to productView route when add header button is tapped',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        var navigatedToAddProduct = false;
        when(() => mockProductsCubit.state)
            .thenReturn(ProductsSuccess(products: []));

        await tester.pumpWidget(
          buildTestWidget(
            routes: {
              Routes.productView: (context) {
                navigatedToAddProduct = true;
                return const Scaffold(body: Text('Add Product View'));
              },
            },
          ),
        );

        // Act
        final addButton = find.byType(HeaderActionButton);
        expect(addButton, findsOneWidget);
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToAddProduct, isTrue);
      },
    );

    testWidgets('should pop view when back arrow is tapped in app bar', (
      WidgetTester tester,
    ) async {
      setPhoneViewport(tester);
      // Arrange
      when(() => mockProductsCubit.state)
          .thenReturn(ProductsSuccess(products: []));

      await tester.pumpWidget(
        createWidgetForTesting(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ProductsView())),
              child: const Text('Open Products'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open ProductsView
      await tester.tap(find.text('Open Products'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductsView), findsOneWidget);

      // Act: tap back arrow
      final backButton = find.byType(CustomArrowBack);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProductsView), findsNothing);
      expect(find.text('Open Products'), findsOneWidget);
    });
  });
}
