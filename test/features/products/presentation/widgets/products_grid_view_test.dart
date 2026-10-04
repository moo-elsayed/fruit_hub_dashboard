import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/custom_product_item.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/products_grid_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockProductsCubit extends MockCubit<ProductsState>
    implements ProductsCubit {}

void main() {
  group('ProductsGridView Widget Tests', () {
    late MockProductsCubit mockProductsCubit;

    const tFruits = [
      FruitEntity(name: 'Apple', code: 'APP01', price: 20.0),
      FruitEntity(name: 'Banana', code: 'BAN02', price: 15.0),
      FruitEntity(name: 'Cherry', code: 'CHE03', price: 35.0),
    ];

    setUp(() {
      mockProductsCubit = MockProductsCubit();
      when(() => mockProductsCubit.state).thenReturn(ProductsInitial());
    });

    Widget buildTestWidget({List<FruitEntity>? fruits, int? itemCount}) =>
        createWidgetForTesting(
          child: BlocProvider<ProductsCubit>.value(
            value: mockProductsCubit,
            child: ProductsGridView(fruits: fruits, itemCount: itemCount),
          ),
        );

    testWidgets(
      'should render exact number of CustomProductItem widgets when fruits list is provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget(fruits: tFruits));

        // Assert
        expect(find.byType(CustomProductItem), findsNWidgets(3));
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Cherry'), findsOneWidget);
      },
    );

    testWidgets(
      'should render exact number of items when itemCount is provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget(itemCount: 4));

        // Assert
        expect(find.byType(CustomProductItem), findsNWidgets(4));
      },
    );

    testWidgets(
      'should render empty grid when neither fruits nor itemCount is provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());

        // Assert
        expect(find.byType(CustomProductItem), findsNothing);
      },
    );
  });
}
