import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late AddProductUseCase sut;
  late MockProductsRepo mockProductsRepo;
  const fruitEntity = FruitEntity(
    code: '004029',
    name: 'Fruit',
    price: 10.0,
    isFeatured: true,
    isOrganic: true,
  );

  final tException = Exception('DataSource error');
  const tSuccessResponseOfTypeVoid = NetworkSuccess<void>(null);
  final tFailureResponseOfTypeVoid = NetworkFailure<void>(tException);

  setUpAll(() {
    registerFallbackValue(const FruitEntity());
  });

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = AddProductUseCase(mockProductsRepo);
  });

  group('AddProductUseCase', () {
    test('should add product successfully', () async {
      // Arrange
      when(
        () => mockProductsRepo.addProduct(fruitEntity),
      ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
      // Act
      final result = await sut.call(fruitEntity);
      // Assert
      expect(result, tSuccessResponseOfTypeVoid);
      verify(() => mockProductsRepo.addProduct(fruitEntity)).called(1);
      verifyNoMoreInteractions(mockProductsRepo);
    });
    test(
      'should return NetworkFailure when addProduct throws an exception',
      () async {
        // Arrange
        when(
          () => mockProductsRepo.addProduct(fruitEntity),
        ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
        // Act
        final result = await sut.call(fruitEntity);
        // Assert
        expect(result, tFailureResponseOfTypeVoid);
        verify(() => mockProductsRepo.addProduct(fruitEntity)).called(1);
        verifyNoMoreInteractions(mockProductsRepo);
      },
    );
  });
}
