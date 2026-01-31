import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

class MockAddProductUseCase extends Mock implements AddProductUseCase {}

class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

class MockUpdateProductUseCase extends Mock implements UpdateProductUseCase {}

void main() {
  late ProductsCubit sut;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockAddProductUseCase mockAddProductUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;

  const tFruit = FruitEntity(
    code: '123',
    name: 'Mango',
    price: 50,
    imagePath: 'image',
    description: 'desc',
    isFeatured: false,
    isOrganic: false,
  );
  final tFruitsList = [tFruit];

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockAddProductUseCase = MockAddProductUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();
    mockUpdateProductUseCase = MockUpdateProductUseCase();
    sut = ProductsCubit(
      mockAddProductUseCase,
      mockGetProductsUseCase,
      mockDeleteProductUseCase,
      mockUpdateProductUseCase,
    );
  });

  tearDown(() => sut.close());

  group('ProductsCubit', () {
    test('initial state should be ProductsInitial', () {
      expect(sut.state, isA<ProductsInitial>());
    });
    group('addProduct', () {
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsSuccess] when addProduct is successful',
        build: () => sut,
        setUp: () {
          when(
            () => mockAddProductUseCase.call(tFruit),
          ).thenAnswer((_) async => const NetworkSuccess<void>(null));
          when(() => mockGetProductsUseCase.call()).thenAnswer(
            (_) async => NetworkSuccess<List<FruitEntity>>(tFruitsList),
          );
        },
        act: (cubit) => cubit.addProduct(tFruit),
        expect: () => [
          isA<ProductsLoading>().having(
            (state) => state.newItemAdded,
            'newItemAdded',
            true,
          ),
          isA<ProductsSuccess>()
              .having((state) => state.newItemAdded, 'newItemAdded', true)
              .having((state) => state.products, 'products', tFruitsList)
              .having((state) => state.itemRemoved, 'itemRemoved', false)
              .having((state) => state.itemUpdated, 'itemUpdated', false),
        ],
        verify: (_) {
          verify(() => mockAddProductUseCase.call(tFruit)).called(1);
          verify(() => mockGetProductsUseCase.call()).called(1);
          verifyNoMoreInteractions(mockAddProductUseCase);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsFailure] when addProduct fails',
        build: () => sut,
        setUp: () {
          when(
            () => mockAddProductUseCase.call(tFruit),
          ).thenAnswer((_) async => NetworkFailure<void>(Exception('error')));
        },
        act: (cubit) => cubit.addProduct(tFruit),
        expect: () => [
          isA<ProductsLoading>().having(
            (state) => state.newItemAdded,
            'newItemAdded',
            true,
          ),
          isA<ProductsFailure>().having(
            (state) => state.errorMessage,
            'message',
            'error',
          ),
        ],
        verify: (_) {
          verify(() => mockAddProductUseCase.call(tFruit)).called(1);
          verifyNoMoreInteractions(mockAddProductUseCase);
        },
      );
    });
    group('getProducts', () {
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsSuccess] when getProducts is successful',
        build: () => sut,
        setUp: () {
          when(() => mockGetProductsUseCase.call()).thenAnswer(
            (_) async => NetworkSuccess<List<FruitEntity>>(tFruitsList),
          );
        },
        act: (cubit) => cubit.getProducts(),
        expect: () => [
          isA<ProductsLoading>(),
          isA<ProductsSuccess>()
              .having((state) => state.products, 'products', tFruitsList)
              .having((state) => state.newItemAdded, 'newItemAdded', false)
              .having((state) => state.itemRemoved, 'itemRemoved', false)
              .having((state) => state.itemUpdated, 'itemUpdated', false),
        ],
        verify: (_) {
          verify(() => mockGetProductsUseCase.call()).called(1);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsSuccess] ONLY when getProducts called with needLoading: false',
        build: () => sut,
        setUp: () {
          when(() => mockGetProductsUseCase.call()).thenAnswer(
            (_) async => NetworkSuccess<List<FruitEntity>>(tFruitsList),
          );
        },
        act: (cubit) => cubit.getProducts(needLoading: false),
        expect: () => [
          isA<ProductsSuccess>()
              .having((state) => state.products, 'products', tFruitsList)
              .having((state) => state.newItemAdded, 'newItemAdded', false)
              .having((state) => state.itemRemoved, 'itemRemoved', false)
              .having((state) => state.itemUpdated, 'itemUpdated', false),
        ],
        verify: (_) {
          verify(() => mockGetProductsUseCase.call()).called(1);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
      blocTest<ProductsCubit, ProductsState>(
        'emits ProductsSuccess with correct flags (e.g. itemRemoved)',
        build: () => sut,
        setUp: () {
          when(() => mockGetProductsUseCase.call()).thenAnswer(
            (_) async => NetworkSuccess<List<FruitEntity>>(tFruitsList),
          );
        },
        act: (cubit) =>
            cubit.getProducts(itemRemoved: true, needLoading: false),
        expect: () => [
          isA<ProductsSuccess>()
              .having((state) => state.itemRemoved, 'itemRemoved', true)
              .having((s) => s.newItemAdded, 'newItemAdded', false),
        ],
        verify: (_) {
          verify(() => mockGetProductsUseCase.call()).called(1);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsFailure] when getProducts fails',
        build: () => sut,
        setUp: () {
          when(() => mockGetProductsUseCase.call()).thenAnswer(
            (_) async => NetworkFailure<List<FruitEntity>>(Exception('error')),
          );
        },
        act: (cubit) => cubit.getProducts(),
        expect: () => [
          isA<ProductsLoading>(),
          isA<ProductsFailure>().having(
            (state) => state.errorMessage,
            'message',
            'error',
          ),
        ],
        verify: (_) {
          verify(() => mockGetProductsUseCase.call()).called(1);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
    });
    group('deleteProduct', () {
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsSuccess] when deleteProduct is successful',
        build: () => sut,
        setUp: () {
          when(
            () => mockDeleteProductUseCase.call(tFruit.code),
          ).thenAnswer((_) async => const NetworkSuccess<void>(null));
          when(() => mockGetProductsUseCase.call()).thenAnswer(
            (_) async => NetworkSuccess<List<FruitEntity>>(tFruitsList),
          );
        },
        act: (cubit) => cubit.deleteProduct(tFruit.code),
        expect: () => [
          isA<ProductsLoading>().having(
            (state) => state.itemRemoved,
            'itemRemoved',
            true,
          ),
          isA<ProductsSuccess>()
              .having((state) => state.itemRemoved, 'itemRemoved', true)
              .having((state) => state.products, 'products', tFruitsList)
              .having((state) => state.newItemAdded, 'newItemAdded', false)
              .having((state) => state.itemUpdated, 'itemUpdated', false),
        ],
        verify: (_) {
          verify(() => mockDeleteProductUseCase.call(tFruit.code)).called(1);
          verify(() => mockGetProductsUseCase.call()).called(1);
          verifyNoMoreInteractions(mockDeleteProductUseCase);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsFailure] when deleteProduct fails',
        build: () => sut,
        setUp: () {
          when(
            () => mockDeleteProductUseCase.call(tFruit.code),
          ).thenAnswer((_) async => NetworkFailure<void>(Exception('error')));
        },
        act: (cubit) => cubit.deleteProduct(tFruit.code),
        expect: () => [
          isA<ProductsLoading>().having(
            (state) => state.itemRemoved,
            'itemRemoved',
            true,
          ),
          isA<ProductsFailure>().having(
            (state) => state.errorMessage,
            'message',
            'error',
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteProductUseCase.call(tFruit.code)).called(1);
          verifyNoMoreInteractions(mockDeleteProductUseCase);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
    });
    group('updateProduct', () {
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsSuccess] when updateProduct is successful',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateProductUseCase.call(tFruit),
          ).thenAnswer((_) async => const NetworkSuccess<void>(null));
          when(() => mockGetProductsUseCase.call()).thenAnswer(
            (_) async => NetworkSuccess<List<FruitEntity>>(tFruitsList),
          );
        },
        act: (cubit) => cubit.updateProduct(tFruit),
        expect: () => [
          isA<ProductsLoading>().having(
            (state) => state.itemUpdated,
            'itemUpdated',
            true,
          ),
          isA<ProductsSuccess>()
              .having((state) => state.itemUpdated, 'itemUpdated', true)
              .having((state) => state.products, 'products', tFruitsList)
              .having((state) => state.newItemAdded, 'newItemAdded', false)
              .having((state) => state.itemRemoved, 'itemRemoved', false),
        ],
        verify: (_) {
          verify(() => mockUpdateProductUseCase.call(tFruit)).called(1);
          verify(() => mockGetProductsUseCase.call()).called(1);
          verifyNoMoreInteractions(mockUpdateProductUseCase);
        },
      );
      blocTest<ProductsCubit, ProductsState>(
        'emits [ProductsLoading, ProductsFailure] when updateProduct fails',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateProductUseCase.call(tFruit),
          ).thenAnswer((_) async => NetworkFailure<void>(Exception('error')));
        },
        act: (cubit) => cubit.updateProduct(tFruit),
        expect: () => [
          isA<ProductsLoading>().having(
            (state) => state.itemUpdated,
            'itemUpdated',
            true,
          ),
          isA<ProductsFailure>().having(
            (state) => state.errorMessage,
            'message',
            'error',
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateProductUseCase.call(tFruit)).called(1);
          verifyNoMoreInteractions(mockUpdateProductUseCase);
          verifyNoMoreInteractions(mockGetProductsUseCase);
        },
      );
    });
  });
}
