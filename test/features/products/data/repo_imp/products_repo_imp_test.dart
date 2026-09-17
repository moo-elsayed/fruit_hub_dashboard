import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/products/data/models/fruit_model.dart';
import 'package:fruit_hub_dashboard/features/products/data/models/review_model.dart';
import 'package:fruit_hub_dashboard/features/products/data/repo_imp/products_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/review_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRemoteDataSource extends Mock
    implements ProductsRemoteDataSource {}

class FakeFruitModel extends Fake implements FruitModel {}

class MockXFile extends Mock implements XFile {}

void main() {
  late MockProductsRemoteDataSource mockRemoteDataSource;
  late MockXFile mockImage;
  late ProductsRepoImp sut;

  const tFailure = ServerFailure(error: 'Server error occurred');
  final tImageBytes = Uint8List.fromList([1, 2, 3, 4]);
  const tImageName = 'strawberry.png';

  final tReviewEntity = ReviewEntity(
    name: 'John',
    image: 'https://example.com/john.png',
    rating: 5,
    date: '2026-09-17',
    description: 'Great fruit!',
  );

  final tReviewModel = ReviewModel(
    name: 'John',
    image: 'https://example.com/john.png',
    rating: 5,
    date: '2026-09-17',
    description: 'Great fruit!',
  );

  FruitEntity createFruitEntity({XFile? image}) => FruitEntity(
    name: 'Strawberry',
    code: 'STR123',
    description: 'Fresh strawberry',
    price: 50.0,
    isFeatured: true,
    isOrganic: true,
    imagePath: 'https://example.com/strawberry.png',
    image: image,
    numberOfCalories: 32,
    weightInGrams: 500,
    daysUntilExpiration: 7,
    ratingCount: 10,
    avgRating: 4.5,
    reviews: [tReviewEntity],
  );

  final tFruitEntityWithoutImage = createFruitEntity(image: null);

  final tFruitModel = FruitModel(
    name: 'Strawberry',
    code: 'STR123',
    description: 'Fresh strawberry',
    price: 50.0,
    isFeatured: true,
    isOrganic: true,
    imagePath: 'https://example.com/strawberry.png',
    numberOfCalories: 32,
    weightInGrams: 500,
    daysUntilExpiration: 7,
    ratingCount: 10,
    avgRating: 4.5,
    sellingCount: 0,
    reviews: [tReviewModel],
  );

  setUpAll(() {
    registerFallbackValue(FakeFruitModel());
  });

  setUp(() {
    mockRemoteDataSource = MockProductsRemoteDataSource();
    mockImage = MockXFile();
    sut = ProductsRepoImp(mockRemoteDataSource);

    when(() => mockImage.readAsBytes()).thenAnswer((_) async => tImageBytes);
    when(() => mockImage.name).thenReturn(tImageName);
  });

  group('addProduct', () {
    test('should extract image bytes & name and call remoteDataSource.addProduct successfully', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.addProduct(
          any(),
          imageBytes: any(named: 'imageBytes'),
          imageName: any(named: 'imageName'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess(null));

      // Act
      final result = await sut.addProduct(createFruitEntity(image: mockImage));

      // Assert
      expect(result, isA<NetworkSuccess<void>>());
      verify(
        () => mockRemoteDataSource.addProduct(
          any(that: isA<FruitModel>().having((m) => m.code, 'code', 'STR123')),
          imageBytes: tImageBytes,
          imageName: tImageName,
        ),
      ).called(1);
    });

    test('should pass null for imageBytes & imageName when fruitEntity has no image', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.addProduct(
          any(),
          imageBytes: any(named: 'imageBytes'),
          imageName: any(named: 'imageName'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess(null));

      // Act
      final result = await sut.addProduct(tFruitEntityWithoutImage);

      // Assert
      expect(result, isA<NetworkSuccess<void>>());
      verify(
        () => mockRemoteDataSource.addProduct(
          any(that: isA<FruitModel>().having((m) => m.code, 'code', 'STR123')),
          imageBytes: null,
          imageName: null,
        ),
      ).called(1);
    });

    test(
      'should return NetworkFailure when remoteDataSource.addProduct fails',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.addProduct(
            any(),
            imageBytes: any(named: 'imageBytes'),
            imageName: any(named: 'imageName'),
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.addProduct(tFruitEntityWithoutImage);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure, equals(tFailure));
      },
    );
  });

  group('getAllProducts', () {
    test('should return mapped List<FruitEntity> on NetworkSuccess', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAllProducts())
          .thenAnswer((_) async => NetworkSuccess([tFruitModel]));

      // Act
      final result = await sut.getAllProducts();

      // Assert
      expect(result, isA<NetworkSuccess<List<FruitEntity>>>());
      final entities = (result as NetworkSuccess<List<FruitEntity>>).data!;
      expect(entities.length, 1);
      expect(entities.first.code, tFruitModel.code);
      expect(entities.first.name, tFruitModel.name);
      expect(entities.first.price, tFruitModel.price);
      expect(entities.first.reviews.length, 1);
      expect(entities.first.reviews.first.description, 'Great fruit!');
      verify(() => mockRemoteDataSource.getAllProducts()).called(1);
    });

    test(
      'should return NetworkFailure when remoteDataSource.getAllProducts fails',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.getAllProducts())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.getAllProducts();

        // Assert
        expect(result, isA<NetworkFailure<List<FruitEntity>>>());
        final failure = (result as NetworkFailure<List<FruitEntity>>).failure;
        expect(failure, equals(tFailure));
        verify(() => mockRemoteDataSource.getAllProducts()).called(1);
      },
    );
  });

  group('deleteProduct', () {
    const tCode = 'STR123';

    test('should delegate to remoteDataSource.deleteProduct and return NetworkSuccess', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteProduct(tCode))
          .thenAnswer((_) async => const NetworkSuccess(null));

      // Act
      final result = await sut.deleteProduct(tCode);

      // Assert
      expect(result, isA<NetworkSuccess<void>>());
      verify(() => mockRemoteDataSource.deleteProduct(tCode)).called(1);
    });

    test(
      'should return NetworkFailure when remoteDataSource.deleteProduct fails',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.deleteProduct(tCode))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.deleteProduct(tCode);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure, equals(tFailure));
        verify(() => mockRemoteDataSource.deleteProduct(tCode)).called(1);
      },
    );
  });

  group('updateProduct', () {
    test('should extract image bytes & name and call remoteDataSource.updateProduct successfully', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.updateProduct(
          any(),
          imageBytes: any(named: 'imageBytes'),
          imageName: any(named: 'imageName'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess(null));

      // Act
      final result = await sut.updateProduct(
        createFruitEntity(image: mockImage),
      );

      // Assert
      expect(result, isA<NetworkSuccess<void>>());
      verify(
        () => mockRemoteDataSource.updateProduct(
          any(that: isA<FruitModel>().having((m) => m.code, 'code', 'STR123')),
          imageBytes: tImageBytes,
          imageName: tImageName,
        ),
      ).called(1);
    });

    test('should pass null for imageBytes & imageName when fruitEntity has no image', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.updateProduct(
          any(),
          imageBytes: any(named: 'imageBytes'),
          imageName: any(named: 'imageName'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess(null));

      // Act
      final result = await sut.updateProduct(tFruitEntityWithoutImage);

      // Assert
      expect(result, isA<NetworkSuccess<void>>());
      verify(
        () => mockRemoteDataSource.updateProduct(
          any(that: isA<FruitModel>().having((m) => m.code, 'code', 'STR123')),
          imageBytes: null,
          imageName: null,
        ),
      ).called(1);
    });

    test(
      'should return NetworkFailure when remoteDataSource.updateProduct fails',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.updateProduct(
            any(),
            imageBytes: any(named: 'imageBytes'),
            imageName: any(named: 'imageName'),
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.updateProduct(tFruitEntityWithoutImage);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure, equals(tFailure));
      },
    );
  });
}
