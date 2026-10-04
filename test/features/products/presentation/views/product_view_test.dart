import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/views/product_view.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockProductsCubit extends MockCubit<ProductsState>
    implements ProductsCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(const FruitEntity());
  });

  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('ProductView Widget Tests', () {
    late MockProductsCubit mockProductsCubit;
    late StreamController<ProductsState> stateController;

    const tFruit = FruitEntity(
      name: 'Fresh Mango',
      code: 'MAN101',
      price: 50.0,
      description: 'Egyptian mango juicy and sweet',
      imagePath: 'https://example.com/mango.png',
      numberOfCalories: 60,
      weightInGrams: 500,
      daysUntilExpiration: 7,
      isOrganic: true,
      isFeatured: false,
    );

    setUp(() {
      mockProductsCubit = MockProductsCubit();
      stateController = StreamController<ProductsState>.broadcast();

      when(() => mockProductsCubit.state).thenReturn(ProductsInitial());
      when(() => mockProductsCubit.stream)
          .thenAnswer((_) => stateController.stream);
      when(() => mockProductsCubit.addProduct(any())).thenAnswer((_) async {});
      when(() => mockProductsCubit.updateProduct(any()))
          .thenAnswer((_) async {});
    });

    tearDown(() {
      stateController.close();
    });

    Widget buildTestWidget({
      FruitEntity? fruitEntity,
      NavigatorObserver? navigatorObserver,
    }) => createWidgetForTesting(
      navigatorObserver: navigatorObserver,
      withToastification: true,
      child: BlocProvider<ProductsCubit>.value(
        value: mockProductsCubit,
        child: ProductView(fruitEntity: fruitEntity),
      ),
    );

    testWidgets(
      'should render add product title and submit button in add mode',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());

        // Assert
        expect(
          find.descendant(
            of: find.byType(CustomAppBar),
            matching: find.text(AppStrings.addProduct),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(CustomMaterialButton),
            matching: find.text(AppStrings.addProduct),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should render edit product title and prefill values in edit mode',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget(fruitEntity: tFruit));

        // Assert
        expect(
          find.descendant(
            of: find.byType(CustomAppBar),
            matching: find.text(AppStrings.editProduct),
          ),
          findsOneWidget,
        );
        expect(find.text('Fresh Mango'), findsOneWidget);
        expect(find.text('MAN101'), findsOneWidget);
        expect(find.text('50.0'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(CustomMaterialButton),
            matching: find.text(AppStrings.editProduct),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should not submit form and show validation errors when fields are empty',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        await tester.pumpWidget(buildTestWidget());

        // Act - Tap submit without filling fields
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pumpAndSettle();

        // Assert - addProduct was NOT called
        verifyNever(() => mockProductsCubit.addProduct(any()));
      },
    );

    testWidgets(
      'should not call updateProduct and show noChangesToSave when submitting unmodified form in edit mode',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        await tester.pumpWidget(buildTestWidget(fruitEntity: tFruit));

        // Act - Tap submit without modifying anything
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert updateProduct was NOT called and toast shown
        expect(
          find.text(AppStrings.noChangesToSave, skipOffstage: false),
          findsOneWidget,
        );
        verifyNever(() => mockProductsCubit.updateProduct(any()));

        toastification.dismissAll();
        await tester.pump(const Duration(seconds: 3));
      },
    );

    testWidgets(
      'should call updateProduct when submitting modified form in edit mode',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        await tester.pumpWidget(buildTestWidget(fruitEntity: tFruit));

        // Act - Modify price field and tap submit
        await tester.enterText(find.text('50.0'), '75.0');
        await tester.pump();

        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();

        // Assert updateProduct called
        verify(() => mockProductsCubit.updateProduct(any())).called(1);
      },
    );

    testWidgets('should pop view when back arrow is tapped', (
      WidgetTester tester,
    ) async {
      setPhoneViewport(tester);
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<ProductsCubit>.value(
                    value: mockProductsCubit,
                    child: const ProductView(),
                  ),
                ),
              ),
              child: const Text('Open Product'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open ProductView
      await tester.tap(find.text('Open Product'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductView), findsOneWidget);

      // Act: tap back arrow
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProductView), findsNothing);
      expect(find.text('Open Product'), findsOneWidget);
    });
  });
}
