import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late MockProductsRepo mockProductsRepo;
  late UpdateProductUseCase sut;

  const tFruitEntity = FruitEntity(
    name: 'Strawberry',
    code: 'STR123',
    price: 60.0,
  );

  const tFailure = ServerFailure(error: 'Failed to update product');

  setUpAll(() {
    registerFallbackValue(tFruitEntity);
  });

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = UpdateProductUseCase(mockProductsRepo);
  });

  group('UpdateProductUseCase', () {
    test(
      'should forward call to repo.updateProduct and return NetworkSuccess',
      () async {
        // Arrange
        when(() => mockProductsRepo.updateProduct(any()))
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut(tFruitEntity);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(() => mockProductsRepo.updateProduct(tFruitEntity)).called(1);
      },
    );

    test(
      'should return NetworkFailure when repo.updateProduct fails',
      () async {
        // Arrange
        when(() => mockProductsRepo.updateProduct(any()))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(tFruitEntity);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure, equals(tFailure));
        verify(() => mockProductsRepo.updateProduct(tFruitEntity)).called(1);
      },
    );
  });
}
