import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/products/data/repo_imp/products_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRemoteDataSource extends Mock
    implements ProductsRemoteDataSource {}

void main() {
  late ProductsRepoImp sut;
  late MockProductsRemoteDataSource mockProductsRemoteDataSource;
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

  const fruit1 = FruitEntity(
    name: 'Apple',
    price: 20,
    code: '1',
    description: '',
    imagePath: '',
  );
  const fruit2 = FruitEntity(
    name: 'Orange',
    price: 30,
    code: '3',
    description: '',
    imagePath: '',
  );
  const fruit3 = FruitEntity(
    name: 'Banana',
    price: 10,
    code: '2',
    description: '',
    imagePath: '',
  );

  final List<FruitEntity> fruits = [fruit1, fruit2, fruit3];

  final tSuccessResponse = NetworkSuccess<List<FruitEntity>>(fruits);
  final tFailureResponse = NetworkFailure<List<FruitEntity>>(
    Exception('permission-denied'),
  );

  setUpAll(() {
    registerFallbackValue(const FruitEntity());
  });

  setUp(() {
    mockProductsRemoteDataSource = MockProductsRemoteDataSource();
    sut = ProductsRepoImp(mockProductsRemoteDataSource);
  });

  group('ProductsRepoImp', () {
    group('addProduct', () {
      test(
        'should return NetworkSuccess when addProduct is successful',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.addProduct(any()),
          ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
          // Act
          final result = await sut.addProduct(fruitEntity);
          // Assert
          expect(result, tSuccessResponseOfTypeVoid);
          verify(
            () => mockProductsRemoteDataSource.addProduct(any()),
          ).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );

      test(
        'should return NetworkFailure when addProduct throws an exception',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.addProduct(any()),
          ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
          // Act
          final result = await sut.addProduct(fruitEntity);
          // Assert
          expect(result, tFailureResponseOfTypeVoid);
          verify(
            () => mockProductsRemoteDataSource.addProduct(any()),
          ).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );
    });
    group('getAllProducts', () {
      test(
        'should return NetworkSuccess when getAllProducts is successful',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => tSuccessResponse);
          // Act
          final result = await sut.getAllProducts();
          // Assert
          expect(result, tSuccessResponse);
          verify(() => mockProductsRemoteDataSource.getAllProducts()).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );
      test(
        'should return NetworkFailure when getAllProducts throws an exception',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => tFailureResponse);
          // Act
          final result = await sut.getAllProducts();
          // Assert
          expect(result, tFailureResponse);
          verify(() => mockProductsRemoteDataSource.getAllProducts()).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );
    });
    group('deleteProduct', () {
      test(
        'should return NetworkSuccess when deleteProduct is successful',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.deleteProduct(any()),
          ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
          // Act
          final result = await sut.deleteProduct(fruitEntity.code);
          // Assert
          expect(result, tSuccessResponseOfTypeVoid);
          verify(
            () => mockProductsRemoteDataSource.deleteProduct(any()),
          ).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );
      test(
        'should return NetworkFailure when deleteProduct throws an exception',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.deleteProduct(any()),
          ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
          // Act
          final result = await sut.deleteProduct(fruitEntity.code);
          // Assert
          expect(result, tFailureResponseOfTypeVoid);
          verify(
            () => mockProductsRemoteDataSource.deleteProduct(any()),
          ).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );
    });
    group('updateProduct', () {
      test(
        'should return NetworkSuccess when updateProduct is successful',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.updateProduct(any()),
          ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
          // Act
          final result = await sut.updateProduct(fruitEntity);
          // Assert
          expect(result, tSuccessResponseOfTypeVoid);
          verify(
            () => mockProductsRemoteDataSource.updateProduct(any()),
          ).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );
      test(
        'should return NetworkFailure when updateProduct throws an exception',
        () async {
          // Arrange
          when(
            () => mockProductsRemoteDataSource.updateProduct(any()),
          ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
          // Act
          final result = await sut.updateProduct(fruitEntity);
          // Assert
          expect(result, tFailureResponseOfTypeVoid);
          verify(
            () => mockProductsRemoteDataSource.updateProduct(any()),
          ).called(1);
          verifyNoMoreInteractions(mockProductsRemoteDataSource);
        },
      );
    });
  });
}
