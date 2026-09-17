import 'dart:async';
import 'dart:typed_data';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/helpers/image_compressor.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/products/data/models/fruit_model.dart';
import 'package:fruit_hub_dashboard/features/products/data/models/review_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class FakeUploadTask extends Fake implements UploadTask {
  final MockTaskSnapshot _snapshot = MockTaskSnapshot();

  @override
  Future<S> then<S>(
    FutureOr<S> Function(TaskSnapshot) onValue, {
    Function? onError,
  }) => Future.value(_snapshot).then(onValue, onError: onError);
}

class MockListResult extends Mock implements ListResult {}

class MockImageCompressor extends Mock implements ImageCompressor {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseStorage mockStorage;
  late MockImageCompressor mockImageCompressor;
  late MockReference mockRootRef;
  late MockReference mockChildRef;
  late MockReference mockFileRef;
  late FakeUploadTask fakeUploadTask;
  late MockListResult mockListResult;
  late ProductsRemoteDataSourceImp sut;

  final tReview = ReviewModel(
    name: 'Ahmed',
    image: 'https://example.com/user.png',
    rating: 4.5,
    date: '2026-09-17',
    description: 'Fresh and sweet',
  );

  final tFruitModel = FruitModel(
    name: 'Strawberry',
    description: 'Fresh organic strawberries',
    price: 45.0,
    imagePath: 'https://example.com/strawberry.png',
    code: 'STR123',
    isFeatured: true,
    avgRating: 4.8,
    ratingCount: 15,
    isOrganic: true,
    daysUntilExpiration: 7,
    weightInGrams: 500,
    numberOfCalories: 32,
    reviews: [tReview],
    sellingCount: 120,
  );

  final tImageBytes = Uint8List.fromList([1, 2, 3, 4]);
  final tCompressedBytes = Uint8List.fromList([1, 2]);
  const tImageName = 'strawberry.jpg';
  const tDownloadUrl = 'https://storage.googleapis.com/strawberry.jpg';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    mockImageCompressor = MockImageCompressor();
    mockRootRef = MockReference();
    mockChildRef = MockReference();
    mockFileRef = MockReference();
    fakeUploadTask = FakeUploadTask();
    mockListResult = MockListResult();

    when(() => mockStorage.ref()).thenReturn(mockRootRef);
    when(() => mockRootRef.child(any())).thenReturn(mockChildRef);
    when(() => mockChildRef.child(any())).thenReturn(mockFileRef);

    sut = ProductsRemoteDataSourceImp(
      firestore: fakeFirestore,
      firebaseStorage: mockStorage,
      imageCompressor: mockImageCompressor,
    );
  });

  group('ProductsRemoteDataSourceImp', () {
    group('addProduct', () {
      test('should save product to Firestore without image upload when imageBytes is null', () async {
        // Act
        final result = await sut.addProduct(tFruitModel);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final doc = await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .get();

        expect(doc.exists, isTrue);
        expect(doc.data()?['name'], 'Strawberry');
        expect(doc.data()?['code'], 'STR123');
        expect(doc.data()?['imagePath'], tFruitModel.imagePath);

        verifyZeroInteractions(mockStorage);
        verifyZeroInteractions(mockImageCompressor);
      });

      test('should compress image, upload to Storage, and save product with new imageUrl when imageBytes is provided', () async {
        // Arrange
        when(() => mockImageCompressor.compressImage(tImageBytes))
            .thenAnswer((_) async => tCompressedBytes);

        when(() => mockChildRef.putData(tCompressedBytes))
            .thenAnswer((_) => fakeUploadTask);

        when(() => mockChildRef.getDownloadURL())
            .thenAnswer((_) async => tDownloadUrl);

        // Act
        final result = await sut.addProduct(
          tFruitModel,
          imageBytes: tImageBytes,
          imageName: tImageName,
        );

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final doc = await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .get();

        expect(doc.exists, isTrue);
        expect(doc.data()?['imagePath'], tDownloadUrl);

        verify(() => mockImageCompressor.compressImage(tImageBytes)).called(1);
        verify(
          () => mockRootRef.child('images/${tFruitModel.code}/$tImageName'),
        ).called(1);
        verify(() => mockChildRef.putData(tCompressedBytes)).called(1);
        verify(() => mockChildRef.getDownloadURL()).called(1);
      });

      test('should return NetworkFailure with BusinessException message when product code already exists', () async {
        // Arrange - pre-populate product in Firestore
        await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .set(tFruitModel.toJson());

        // Act
        final result = await sut.addProduct(tFruitModel);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure.error, 'Product with this code already exists');

        verifyZeroInteractions(mockStorage);
      });

      test('should return NetworkFailure when image compressor throws an exception', () async {
        // Arrange
        when(() => mockImageCompressor.compressImage(any()))
            .thenThrow(Exception('Compression failed'));

        // Act
        final result = await sut.addProduct(
          tFruitModel,
          imageBytes: tImageBytes,
          imageName: tImageName,
        );

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final doc = await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .get();
        expect(doc.exists, isFalse);
      });
    });

    group('getAllProducts', () {
      test(
        'should return empty list when no products exist in Firestore',
        () async {
          // Act
          final result = await sut.getAllProducts();

          // Assert
          expect(result, isA<NetworkSuccess<List<FruitModel>>>());
          final products = (result as NetworkSuccess<List<FruitModel>>).data!;
          expect(products, isEmpty);
        },
      );

      test(
        'should return list of FruitModels when products exist in Firestore',
        () async {
          // Arrange
          final product2 = tFruitModel.copyWith(
            code: 'BAN456',
            name: 'Banana',
            price: 25.0,
          );

          await fakeFirestore
              .collection(BackendEndpoints.productsCollection)
              .doc(tFruitModel.code)
              .set(tFruitModel.toJson());
          await fakeFirestore
              .collection(BackendEndpoints.productsCollection)
              .doc(product2.code)
              .set(product2.toJson());

          // Act
          final result = await sut.getAllProducts();

          // Assert
          expect(result, isA<NetworkSuccess<List<FruitModel>>>());
          final products = (result as NetworkSuccess<List<FruitModel>>).data!;
          expect(products.length, 2);
          expect(products.any((p) => p.code == 'STR123'), isTrue);
          expect(products.any((p) => p.code == 'BAN456'), isTrue);
        },
      );
    });

    group('deleteProduct', () {
      test(
        'should delete storage images and delete document from Firestore',
        () async {
          // Arrange - populate in Firestore
          await fakeFirestore
              .collection(BackendEndpoints.productsCollection)
              .doc(tFruitModel.code)
              .set(tFruitModel.toJson());

          final mockItem1 = MockReference();
          final mockItem2 = MockReference();
          when(() => mockItem1.delete()).thenAnswer((_) async {});
          when(() => mockItem2.delete()).thenAnswer((_) async {});

          when(() => mockRootRef.child('images/${tFruitModel.code}'))
              .thenReturn(mockChildRef);
          when(() => mockChildRef.listAll())
              .thenAnswer((_) async => mockListResult);
          when(() => mockListResult.items).thenReturn([mockItem1, mockItem2]);

          // Act
          final result = await sut.deleteProduct(tFruitModel.code);

          // Assert
          expect(result, isA<NetworkSuccess<void>>());

          final doc = await fakeFirestore
              .collection(BackendEndpoints.productsCollection)
              .doc(tFruitModel.code)
              .get();
          expect(doc.exists, isFalse);

          verify(() => mockItem1.delete()).called(1);
          verify(() => mockItem2.delete()).called(1);
        },
      );

      test('should successfully delete Firestore doc even if storage deletion fails', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .set(tFruitModel.toJson());

        when(() => mockRootRef.child('images/${tFruitModel.code}'))
            .thenReturn(mockChildRef);
        when(() => mockChildRef.listAll()).thenThrow(
          FirebaseException(
            plugin: 'firebase_storage',
            code: 'object-not-found',
          ),
        );

        // Act
        final result = await sut.deleteProduct(tFruitModel.code);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        final doc = await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .get();
        expect(doc.exists, isFalse);
      });
    });

    group('updateProduct', () {
      test('should update product in Firestore without changing image when imageBytes is null', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .set(tFruitModel.toJson());

        final updatedFruit = tFruitModel.copyWith(
          name: 'Updated Strawberry',
          price: 60.0,
        );

        // Act
        final result = await sut.updateProduct(updatedFruit);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final doc = await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .get();

        expect(doc.data()?['name'], 'Updated Strawberry');
        expect(doc.data()?['price'], 60.0);
        expect(doc.data()?['imagePath'], tFruitModel.imagePath);

        verifyZeroInteractions(mockStorage);
        verifyZeroInteractions(mockImageCompressor);
      });

      test('should delete old storage images, compress and upload new image, and update doc with new url', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .set(tFruitModel.toJson());

        final mockOldItem = MockReference();
        when(() => mockOldItem.delete()).thenAnswer((_) async {});

        when(() => mockRootRef.child('images/${tFruitModel.code}'))
            .thenReturn(mockChildRef);
        when(() => mockChildRef.listAll())
            .thenAnswer((_) async => mockListResult);
        when(() => mockListResult.items).thenReturn([mockOldItem]);

        when(() => mockRootRef.child('images/${tFruitModel.code}/$tImageName'))
            .thenReturn(mockFileRef);
        when(() => mockImageCompressor.compressImage(tImageBytes))
            .thenAnswer((_) async => tCompressedBytes);
        when(() => mockFileRef.putData(tCompressedBytes))
            .thenAnswer((_) => fakeUploadTask);
        when(() => mockFileRef.getDownloadURL())
            .thenAnswer((_) async => tDownloadUrl);

        final updatedFruit = tFruitModel.copyWith(price: 75.0);

        // Act
        final result = await sut.updateProduct(
          updatedFruit,
          imageBytes: tImageBytes,
          imageName: tImageName,
        );

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final doc = await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .get();

        expect(doc.data()?['price'], 75.0);
        expect(doc.data()?['imagePath'], tDownloadUrl);

        verify(() => mockOldItem.delete()).called(1);
        verify(() => mockImageCompressor.compressImage(tImageBytes)).called(1);
        verify(() => mockFileRef.putData(tCompressedBytes)).called(1);
        verify(() => mockFileRef.getDownloadURL()).called(1);
      });

      test('should succeed in updating product even if deleting old storage images throws exception', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .set(tFruitModel.toJson());

        when(() => mockRootRef.child('images/${tFruitModel.code}'))
            .thenReturn(mockChildRef);
        when(() => mockChildRef.listAll()).thenThrow(
          FirebaseException(
            plugin: 'firebase_storage',
            code: 'permission-denied',
          ),
        );

        when(() => mockRootRef.child('images/${tFruitModel.code}/$tImageName'))
            .thenReturn(mockFileRef);
        when(() => mockImageCompressor.compressImage(tImageBytes))
            .thenAnswer((_) async => tCompressedBytes);
        when(() => mockFileRef.putData(tCompressedBytes))
            .thenAnswer((_) => fakeUploadTask);
        when(() => mockFileRef.getDownloadURL())
            .thenAnswer((_) async => tDownloadUrl);

        // Act
        final result = await sut.updateProduct(
          tFruitModel,
          imageBytes: tImageBytes,
          imageName: tImageName,
        );

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final doc = await fakeFirestore
            .collection(BackendEndpoints.productsCollection)
            .doc(tFruitModel.code)
            .get();

        expect(doc.data()?['imagePath'], tDownloadUrl);
      });
    });
  });
}
