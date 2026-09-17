import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late MockProductsRepo mockProductsRepo;
  late DeleteProductUseCase sut;

  const tCode = 'STR123';
  const tFailure = ServerFailure(error: 'Failed to delete product');

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = DeleteProductUseCase(mockProductsRepo);
  });

  group('DeleteProductUseCase', () {
    test(
      'should forward call to repo.deleteProduct and return NetworkSuccess',
      () async {
        // Arrange
        when(() => mockProductsRepo.deleteProduct(tCode))
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut(tCode);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(() => mockProductsRepo.deleteProduct(tCode)).called(1);
      },
    );

    test(
      'should return NetworkFailure when repo.deleteProduct fails',
      () async {
        // Arrange
        when(() => mockProductsRepo.deleteProduct(tCode))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(tCode);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure, equals(tFailure));
        verify(() => mockProductsRepo.deleteProduct(tCode)).called(1);
      },
    );
  });
}
