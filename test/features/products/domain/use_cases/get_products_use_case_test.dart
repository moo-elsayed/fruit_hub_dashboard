import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late MockProductsRepo mockProductsRepo;
  late GetProductsUseCase sut;

  const tProducts = [
    FruitEntity(name: 'Strawberry', code: 'STR123', price: 50.0),
  ];

  const tFailure = ServerFailure(error: 'Failed to get products');

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = GetProductsUseCase(mockProductsRepo);
  });

  group('GetProductsUseCase', () {
    test('should call repo.getAllProducts and return NetworkSuccess with products list', () async {
      // Arrange
      when(() => mockProductsRepo.getAllProducts())
          .thenAnswer((_) async => const NetworkSuccess(tProducts));

      // Act
      final result = await sut();

      // Assert
      expect(result, isA<NetworkSuccess<List<FruitEntity>>>());
      final data = (result as NetworkSuccess<List<FruitEntity>>).data;
      expect(data, equals(tProducts));
      verify(() => mockProductsRepo.getAllProducts()).called(1);
    });

    test(
      'should return NetworkFailure when repo.getAllProducts fails',
      () async {
        // Arrange
        when(() => mockProductsRepo.getAllProducts())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut();

        // Assert
        expect(result, isA<NetworkFailure<List<FruitEntity>>>());
        final failure = (result as NetworkFailure<List<FruitEntity>>).failure;
        expect(failure, equals(tFailure));
        verify(() => mockProductsRepo.getAllProducts()).called(1);
      },
    );
  });
}
