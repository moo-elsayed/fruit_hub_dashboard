import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late MockProductsRepo mockProductsRepo;
  late AddProductUseCase sut;

  const tFruitEntity = FruitEntity(
    name: 'Strawberry',
    code: 'STR123',
    price: 50.0,
  );

  const tFailure = ServerFailure(error: 'Failed to add product');

  setUpAll(() {
    registerFallbackValue(tFruitEntity);
  });

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = AddProductUseCase(mockProductsRepo);
  });

  group('AddProductUseCase', () {
    test(
      'should forward call to repo.addProduct and return NetworkSuccess',
      () async {
        // Arrange
        when(() => mockProductsRepo.addProduct(any()))
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut(tFruitEntity);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(() => mockProductsRepo.addProduct(tFruitEntity)).called(1);
      },
    );

    test('should return NetworkFailure when repo.addProduct fails', () async {
      // Arrange
      when(() => mockProductsRepo.addProduct(any()))
          .thenAnswer((_) async => const NetworkFailure(tFailure));

      // Act
      final result = await sut(tFruitEntity);

      // Assert
      expect(result, isA<NetworkFailure<void>>());
      final failure = (result as NetworkFailure<void>).failure;
      expect(failure, equals(tFailure));
      verify(() => mockProductsRepo.addProduct(tFruitEntity)).called(1);
    });
  });
}
