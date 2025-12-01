import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late UpdateProductUseCase sut;
  late MockProductsRepo mockProductsRepo;

  var fruitEntity = const FruitEntity(
    code: '004029',
    name: 'Fruit',
    price: 10.0,
    isFeatured: true,
    isOrganic: true,
  );

  final tException = Exception('DataSource error');
  final tSuccessResponseOfTypeVoid = const NetworkSuccess<void>(null);
  final tFailureResponseOfTypeVoid = NetworkFailure<void>(tException);

  setUpAll(() {
    registerFallbackValue(const FruitEntity());
  });

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = UpdateProductUseCase(mockProductsRepo);
  });

  group('UpdateProductUseCase', () {
    test('should update product successfully', () async {
      // Arrange
      when(
        () => mockProductsRepo.updateProduct(fruitEntity),
      ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
      // Act
      final result = await sut.call(fruitEntity);
      // Assert
      expect(result, tSuccessResponseOfTypeVoid);
      verify(() => mockProductsRepo.updateProduct(fruitEntity)).called(1);
      verifyNoMoreInteractions(mockProductsRepo);
    });
    test(
      'should return NetworkFailure when updateProduct throws an exception',
      () async {
        // Arrange
        when(
          () => mockProductsRepo.updateProduct(fruitEntity),
        ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
        // Act
        final result = await sut.call(fruitEntity);
        // Assert
        expect(result, tFailureResponseOfTypeVoid);
        verify(() => mockProductsRepo.updateProduct(fruitEntity)).called(1);
        verifyNoMoreInteractions(mockProductsRepo);
      },
    );
  });
}
