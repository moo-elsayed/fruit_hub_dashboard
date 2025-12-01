import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepo extends Mock implements ProductsRepo {}

void main() {
  late GetProductsUseCase sut;
  late MockProductsRepo mockProductsRepo;

  final fruit1 = const FruitEntity(
    name: 'Apple',
    price: 20,
    code: '1',
    description: '',
    imagePath: '',
  );
  final fruit2 = const FruitEntity(
    name: 'Orange',
    price: 30,
    code: '3',
    description: '',
    imagePath: '',
  );
  final fruit3 = const FruitEntity(
    name: 'Banana',
    price: 10,
    code: '2',
    description: '',
    imagePath: '',
  );

  List<FruitEntity> fruits = [fruit1, fruit2, fruit3];

  final tSuccessResponse = NetworkSuccess<List<FruitEntity>>(fruits);
  final tFailureResponse = NetworkFailure<List<FruitEntity>>(
    Exception("permission-denied"),
  );

  setUp(() {
    mockProductsRepo = MockProductsRepo();
    sut = GetProductsUseCase(mockProductsRepo);
  });

  group('GetProductsUseCase', () {
    test('should get all products successfully', () async {
      // Arrange
      when(
        () => mockProductsRepo.getAllProducts(),
      ).thenAnswer((_) async => tSuccessResponse);
      // Act
      final result = await sut.call();
      // Assert
      expect(result, tSuccessResponse);
      verify(() => mockProductsRepo.getAllProducts()).called(1);
      verifyNoMoreInteractions(mockProductsRepo);
    });
    test(
      'should return NetworkFailure when getAllProducts throws an exception',
      () async {
        // Arrange
        when(
          () => mockProductsRepo.getAllProducts(),
        ).thenAnswer((_) async => tFailureResponse);
        // Act
        final result = await sut.call();
        // Assert
        expect(result, tFailureResponse);
        verify(() => mockProductsRepo.getAllProducts()).called(1);
        verifyNoMoreInteractions(mockProductsRepo);
      },
    );
  });
}
