import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAddProductUseCase extends Mock implements AddProductUseCase {}

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

class MockUpdateProductUseCase extends Mock implements UpdateProductUseCase {}

void main() {
  late MockAddProductUseCase mockAddProductUseCase;
  late MockGetProductsUseCase mockGetAllProductsUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;
  late ProductsCubit sut;

  const tErrorMessage = 'An error occurred';
  const tFailure = ServerFailure(error: tErrorMessage);

  const tFruit1 = FruitEntity(name: 'Strawberry', code: 'STR123', price: 50.0);

  const tFruit2 = FruitEntity(name: 'Banana', code: 'BAN456', price: 30.0);

  setUpAll(() {
    registerFallbackValue(tFruit1);
  });

  setUp(() {
    mockAddProductUseCase = MockAddProductUseCase();
    mockGetAllProductsUseCase = MockGetProductsUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();
    mockUpdateProductUseCase = MockUpdateProductUseCase();

    sut = ProductsCubit(
      mockAddProductUseCase,
      mockGetAllProductsUseCase,
      mockDeleteProductUseCase,
      mockUpdateProductUseCase,
    );
  });

  tearDown(() => sut.close());

  group('ProductsCubit', () {
    test('initial state should be ProductsInitial', () {
      expect(sut.state, isA<ProductsInitial>());
    });

    group('getProducts', () {
      blocTest<ProductsCubit, ProductsState>(
        'should emit [ProductsLoading, ProductsSuccess] when getProducts succeeds with needLoading: true',
        setUp: () {
          when(
            () => mockGetAllProductsUseCase.call(),
          ).thenAnswer((_) async => const NetworkSuccess([tFruit1, tFruit2]));
        },
        build: () => sut,
        act: (cubit) => cubit.getProducts(),
        expect: () => [
          isA<ProductsLoading>(),
          isA<ProductsSuccess>().having((s) => s.products, 'products', [
            tFruit1,
            tFruit2,
          ]),
        ],
        verify: (_) => verify(() => mockGetAllProductsUseCase.call()).called(1),
      );

      blocTest<ProductsCubit, ProductsState>(
        'should emit [ProductsSuccess] directly without ProductsLoading when needLoading: false',
        setUp: () {
          when(() => mockGetAllProductsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess([tFruit1]));
        },
        build: () => sut,
        act: (cubit) => cubit.getProducts(needLoading: false),
        expect: () => [
          isA<ProductsSuccess>().having((s) => s.products, 'products', [
            tFruit1,
          ]),
        ],
        verify: (_) => verify(() => mockGetAllProductsUseCase.call()).called(1),
      );

      blocTest<ProductsCubit, ProductsState>(
        'should emit [ProductsLoading, ProductsFailure] when getProducts fails',
        setUp: () {
          when(() => mockGetAllProductsUseCase.call())
              .thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.getProducts(),
        expect: () => [
          isA<ProductsLoading>(),
          isA<ProductsFailure>().having(
            (s) => s.errorMessage,
            'errorMessage',
            tErrorMessage,
          ),
        ],
        verify: (_) => verify(() => mockGetAllProductsUseCase.call()).called(1),
      );
    });

    group('addProduct', () {
      blocTest<ProductsCubit, ProductsState>(
        'should emit [ProductsLoading(newItemAdded: true), ProductsSuccess(newItemAdded: true)] when addProduct succeeds',
        setUp: () {
          when(() => mockAddProductUseCase.call(any()))
              .thenAnswer((_) async => const NetworkSuccess(null));
          when(() => mockGetAllProductsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess([tFruit1]));
        },
        build: () => sut,
        act: (cubit) => cubit.addProduct(tFruit1),
        expect: () => [
          isA<ProductsLoading>().having(
            (s) => s.newItemAdded,
            'newItemAdded',
            true,
          ),
          isA<ProductsSuccess>()
              .having((s) => s.newItemAdded, 'newItemAdded', true)
              .having((s) => s.products, 'products', [tFruit1]),
        ],
        verify: (_) {
          verify(() => mockAddProductUseCase.call(tFruit1)).called(1);
          verify(() => mockGetAllProductsUseCase.call()).called(1);
        },
      );

      blocTest<ProductsCubit, ProductsState>(
        'should emit [ProductsLoading(newItemAdded: true), ProductsFailure] when addProduct fails',
        setUp: () {
          when(() => mockAddProductUseCase.call(any()))
              .thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.addProduct(tFruit1),
        expect: () => [
          isA<ProductsLoading>().having(
            (s) => s.newItemAdded,
            'newItemAdded',
            true,
          ),
          isA<ProductsFailure>().having(
            (s) => s.errorMessage,
            'errorMessage',
            tErrorMessage,
          ),
        ],
        verify: (_) {
          verify(() => mockAddProductUseCase.call(tFruit1)).called(1);
          verifyZeroInteractions(mockGetAllProductsUseCase);
        },
      );
    });

    group('deleteProduct', () {
      blocTest<ProductsCubit, ProductsState>(
        'should not emit any state when product code is not found in fruits list',
        build: () => sut,
        act: (cubit) => cubit.deleteProduct('UNKNOWN'),
        expect: () => [],
        verify: (_) => verifyZeroInteractions(mockDeleteProductUseCase),
      );

      blocTest<ProductsCubit, ProductsState>(
        'should optimistically remove product and emit success with itemRemoved: true when deleteProduct succeeds',
        setUp: () {
          when(
            () => mockGetAllProductsUseCase.call(),
          ).thenAnswer((_) async => const NetworkSuccess([tFruit1, tFruit2]));
          when(() => mockDeleteProductUseCase.call('STR123'))
              .thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getProducts();
          await cubit.deleteProduct('STR123');
        },
        // skip these states because we don't need to test them in this test case
        //  emit(ProductsLoading());
        // _emitSuccess(newItemAdded, itemRemoved, itemUpdated);
        skip: 2,
        expect: () => [
          isA<ProductsSuccess>()
              .having((s) => s.products, 'products', [tFruit2])
              .having((s) => s.itemRemoved, 'itemRemoved', false),
          isA<ProductsSuccess>()
              .having((s) => s.products, 'products', [tFruit2])
              .having((s) => s.itemRemoved, 'itemRemoved', true),
        ],
        verify: (_) =>
            verify(() => mockDeleteProductUseCase.call('STR123')).called(1),
      );

      blocTest<ProductsCubit, ProductsState>(
        'should rollback product and emit failure then restored list when deleteProduct fails',
        setUp: () {
          when(
            () => mockGetAllProductsUseCase.call(),
          ).thenAnswer((_) async => const NetworkSuccess([tFruit1, tFruit2]));
          when(() => mockDeleteProductUseCase.call('STR123'))
              .thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getProducts();
          await cubit.deleteProduct('STR123');
        },
        // skip these states because we don't need to test them in this test case
        //  emit(ProductsLoading());
        // _emitSuccess(newItemAdded, itemRemoved, itemUpdated);
        skip: 2,
        expect: () => [
          isA<ProductsSuccess>().having((s) => s.products, 'products', [
            tFruit2,
          ]),
          isA<ProductsFailure>().having(
            (s) => s.errorMessage,
            'errorMessage',
            tErrorMessage,
          ),
          isA<ProductsSuccess>().having((s) => s.products, 'products', [
            tFruit1,
            tFruit2,
          ]),
        ],
        verify: (_) =>
            verify(() => mockDeleteProductUseCase.call('STR123')).called(1),
      );
    });

    group('updateProduct', () {
      const tUpdatedFruit = FruitEntity(
        name: 'Strawberry Updated',
        code: 'STR123',
        price: 60.0,
      );

      blocTest<ProductsCubit, ProductsState>(
        'should emit [ProductsLoading(itemUpdated: true), ProductsSuccess(itemUpdated: true)] when updateProduct succeeds',
        setUp: () {
          when(() => mockUpdateProductUseCase.call(any()))
              .thenAnswer((_) async => const NetworkSuccess(null));
          when(() => mockGetAllProductsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess([tUpdatedFruit]));
        },
        build: () => sut,
        act: (cubit) => cubit.updateProduct(tUpdatedFruit),
        expect: () => [
          isA<ProductsLoading>().having(
            (s) => s.itemUpdated,
            'itemUpdated',
            true,
          ),
          isA<ProductsSuccess>()
              .having((s) => s.itemUpdated, 'itemUpdated', true)
              .having((s) => s.products, 'products', [tUpdatedFruit]),
        ],
        verify: (_) {
          verify(() => mockUpdateProductUseCase.call(tUpdatedFruit)).called(1);
          verify(() => mockGetAllProductsUseCase.call()).called(1);
        },
      );

      blocTest<ProductsCubit, ProductsState>(
        'should emit [ProductsLoading(itemUpdated: true), ProductsFailure] when updateProduct fails',
        setUp: () {
          when(() => mockUpdateProductUseCase.call(any()))
              .thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.updateProduct(tUpdatedFruit),
        expect: () => [
          isA<ProductsLoading>().having(
            (s) => s.itemUpdated,
            'itemUpdated',
            true,
          ),
          isA<ProductsFailure>().having(
            (s) => s.errorMessage,
            'errorMessage',
            tErrorMessage,
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateProductUseCase.call(tUpdatedFruit)).called(1);
          verifyZeroInteractions(mockGetAllProductsUseCase);
        },
      );
    });
  });
}
