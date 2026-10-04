import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_confirmation_dialog.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/custom_product_item.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_action_button.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_badge.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockProductsCubit extends MockCubit<ProductsState>
    implements ProductsCubit {}

void main() {
  group('CustomProductItem Widget Tests', () {
    late MockProductsCubit mockProductsCubit;

    const tFruit = FruitEntity(
      name: 'Fresh Mango',
      code: 'MAN101',
      price: 45.0,
      imagePath: 'https://example.com/mango.png',
      isOrganic: false,
      isFeatured: false,
    );

    const tOrganicFeaturedFruit = FruitEntity(
      name: 'Organic Strawberry',
      code: 'STR202',
      price: 60.0,
      imagePath: 'https://example.com/strawberry.png',
      isOrganic: true,
      isFeatured: true,
    );

    setUp(() {
      mockProductsCubit = MockProductsCubit();
      when(() => mockProductsCubit.state).thenReturn(ProductsInitial());
    });

    Widget buildTestWidget({
      required FruitEntity fruit,
      NavigatorObserver? navigatorObserver,
      Map<String, WidgetBuilder>? routes,
    }) => createWidgetForTesting(
      navigatorObserver: navigatorObserver,
      routes: routes,
      child: BlocProvider<ProductsCubit>.value(
        value: mockProductsCubit,
        child: SizedBox(
          width: 300,
          height: 420,
          child: CustomProductItem(fruitEntity: fruit),
        ),
      ),
    );

    testWidgets('should render fruit name, price, and delete button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(buildTestWidget(fruit: tFruit));

      // Assert
      expect(find.text('Fresh Mango'), findsOneWidget);
      expect(find.textContaining('45'), findsOneWidget);
      expect(find.byType(ProductActionButton), findsOneWidget);
      expect(find.byType(ProductBadge), findsNothing);
    });

    testWidgets(
      'should render organic and featured badges when flags are true',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget(fruit: tOrganicFeaturedFruit));

        // Assert
        expect(find.text('Organic Strawberry'), findsOneWidget);
        expect(find.byIcon(Icons.eco_rounded), findsOneWidget);
        expect(find.byIcon(Icons.star_rounded), findsOneWidget);
        expect(find.byType(ProductBadge), findsNWidgets(2));
      },
    );

    testWidgets(
      'should navigate to productView route when item card is tapped',
      (WidgetTester tester) async {
        // Arrange
        var navigatedToProductView = false;
        await tester.pumpWidget(
          buildTestWidget(
            fruit: tFruit,
            routes: {
              Routes.productView: (context) {
                navigatedToProductView = true;
                return const Scaffold(body: Text('Product View'));
              },
            },
          ),
        );

        // Act
        await tester.tap(find.text('Fresh Mango'));
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToProductView, isTrue);
        expect(find.text('Product View'), findsOneWidget);
      },
    );

    testWidgets(
      'should show delete confirmation dialog and call deleteProduct on confirm',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockProductsCubit.deleteProduct(any()))
            .thenAnswer((_) async {});

        await tester.pumpWidget(buildTestWidget(fruit: tFruit));

        // Act - Tap delete button
        await tester.tap(find.byType(ProductActionButton));
        await tester.pumpAndSettle();

        // Assert dialog is visible
        expect(find.byType(CustomConfirmationDialog), findsOneWidget);
        expect(find.text(AppStrings.deleteProduct), findsOneWidget);
        expect(find.text(AppStrings.deleteProductConfirmation), findsOneWidget);

        // Act - Tap confirm button
        await tester.tap(find.text(AppStrings.yes));
        await tester.pumpAndSettle();

        // Assert deleteProduct was called with fruit code
        verify(() => mockProductsCubit.deleteProduct(tFruit.code)).called(1);
      },
    );
  });
}
