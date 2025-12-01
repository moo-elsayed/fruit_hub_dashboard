import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late DeleteProductUseCase sut;
  late MockProductsRepo mockProductsRepo;

  final tCode = '004029';
  final tException = Exception('DataSource error');
  final tSuccessResponseOfTypeVoid = const NetworkSuccess<void>(null);
  final tFailureResponseOfTypeVoid = NetworkFailure<void>(tException);

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = DeleteProductUseCase(mockProductsRepo);
  });

  group('DeleteProductUseCase', () {
    test('should delete product successfully', () async {
      // Arrange
      when(
        () => mockProductsRepo.deleteProduct(tCode),
      ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
      // Act
      final result = await sut.call(tCode);
      // Assert
      expect(result, tSuccessResponseOfTypeVoid);
      verify(() => mockProductsRepo.deleteProduct(tCode)).called(1);
      verifyNoMoreInteractions(mockProductsRepo);
    });
    test(
      'should return NetworkFailure when deleteProduct throws an exception',
      () async {
        // Arrange
        when(
          () => mockProductsRepo.deleteProduct(tCode),
        ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
        // Act
        final result = await sut.call(tCode);
        // Assert
        expect(result, tFailureResponseOfTypeVoid);
        verify(() => mockProductsRepo.deleteProduct(tCode)).called(1);
        verifyNoMoreInteractions(mockProductsRepo);
      },
    );
  });
}
