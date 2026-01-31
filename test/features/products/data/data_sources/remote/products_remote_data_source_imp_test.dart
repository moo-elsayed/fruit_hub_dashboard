import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockStorageService extends Mock implements StorageService {}

class MockXFile extends Mock implements XFile {}

void main() {
  late ProductsRemoteDataSourceImp sut;
  late MockDatabaseService mockDatabaseService;
  late MockStorageService mockStorageService;
  late MockXFile mockXFile;

  final tImageBytes = Uint8List.fromList([1, 2, 3]);
  const tCode = '12345';
  const tDownloadUrl = 'https://example.com/image.jpg';
  late FruitEntity tFruitEntity;
  final tProductsData = [
    {
      'name': 'Apple',
      'code': '123',
      'price': 100.0,
      'description': 'Fresh Apple',
      'imagePath': 'url',
      'isFeatured': false,
      'isOrganic': true,
      'daysUntilExpiration': 3,
      'numberOfCalories': 50,
      'unitAmount': 1,
      'avgRating': 4.5,
      'ratingCount': 10,
      'sellingCount': 5,
      'reviews': [],
    },
  ];

  setUpAll(() {
    registerFallbackValue(Uint8List(64));
  });

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockStorageService = MockStorageService();
    sut = ProductsRemoteDataSourceImp(mockDatabaseService, mockStorageService);
    mockXFile = MockXFile();
    when(() => mockXFile.name).thenReturn('fruit.jpg');
    when(() => mockXFile.readAsBytes()).thenAnswer((_) async => tImageBytes);
    when(
      () => mockStorageService.deleteFile(
        bucketName: any(named: 'bucketName'),
        path: any(named: 'path'),
      ),
    ).thenAnswer((_) async {});
    tFruitEntity = FruitEntity(
      image: mockXFile,
      code: tCode,
      name: 'Fruit',
      price: 10.0,
      isFeatured: true,
      isOrganic: true,
    );
  });

  group('ProductsRemoteDataSourceImp', () {
    group('Add product', () {
      test('should add product successfully when it does not exist', () async {
        when(
          () => mockDatabaseService.checkIfDataExists(
            path: any(named: 'path'),
            documentId: any(named: 'documentId'),
          ),
        ).thenAnswer((_) async => false);
        when(
          () => mockStorageService.uploadFile(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode/fruit.jpg',
            data: tImageBytes,
          ),
        ).thenAnswer((_) async => tDownloadUrl);
        when(
          () => mockDatabaseService.addData(
            path: BackendEndpoints.addProduct,
            data: any(named: 'data'),
            docId: tCode,
          ),
        ).thenAnswer((_) async {});
        // Act
        final result = await sut.addProduct(tFruitEntity);
        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockStorageService.uploadFile(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode/fruit.jpg',
            data: tImageBytes,
          ),
        ).called(1);
        verify(
          () => mockDatabaseService.addData(
            path: BackendEndpoints.addProduct,
            data: any(named: 'data'),
            docId: tCode,
          ),
        ).called(1);
      });
      test(
        'should return NetworkFailure when product already exists',
        () async {
          // Arrange
          when(
            () => mockDatabaseService.checkIfDataExists(
              path: any(named: 'path'),
              documentId: tCode,
            ),
          ).thenAnswer((_) async => true);
          // Act
          final result = await sut.addProduct(tFruitEntity);
          // Assert
          expect(result, isA<NetworkFailure<void>>());
          verifyNever(
            () => mockStorageService.uploadFile(
              bucketName: BackendEndpoints.bucketName,
              path: 'images/$tCode/fruit.jpg',
              data: tImageBytes,
            ),
          );
          verifyNever(
            () => mockDatabaseService.addData(
              path: BackendEndpoints.addProduct,
              data: any(named: 'data'),
              docId: tCode,
            ),
          );
        },
      );
      test('should return NetworkFailure if image upload fails', () async {
        // Arrange
        when(
          () => mockDatabaseService.checkIfDataExists(
            path: any(named: 'path'),
            documentId: tCode,
          ),
        ).thenAnswer((_) async => false);
        when(
          () => mockStorageService.uploadFile(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode/fruit.jpg',
            data: tImageBytes,
          ),
        ).thenThrow(Exception('Storage error'));
        // Act
        final result = await sut.addProduct(tFruitEntity);
        // Assert
        expect(result, isA<NetworkFailure<void>>());
        verify(
          () => mockStorageService.uploadFile(
            bucketName: BackendEndpoints.bucketName,
            data: any(named: 'data'),
            path: 'images/$tCode/fruit.jpg',
          ),
        ).called(1);
        verifyNever(
          () => mockStorageService.deleteFile(
            bucketName: any(named: 'bucketName'),
            path: any(named: 'path'),
          ),
        );
        verifyNever(
          () => mockDatabaseService.addData(
            path: BackendEndpoints.addProduct,
            data: any(named: 'data'),
            docId: tCode,
          ),
        );
      });
      test('should delete uploaded image if database addition fails', () async {
        // Arrange
        when(
          () => mockDatabaseService.checkIfDataExists(
            path: any(named: 'path'),
            documentId: tCode,
          ),
        ).thenAnswer((_) async => false);
        when(
          () => mockStorageService.uploadFile(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode/fruit.jpg',
            data: tImageBytes,
          ),
        ).thenAnswer((_) async => tDownloadUrl);
        when(
          () => mockDatabaseService.addData(
            path: BackendEndpoints.addProduct,
            data: any(named: 'data'),
            docId: tCode,
          ),
        ).thenThrow(Exception('Database error'));
        when(
          () => mockStorageService.deleteFile(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode/fruit.jpg',
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await sut.addProduct(tFruitEntity);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        verify(
          () => mockStorageService.deleteFile(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode/fruit.jpg',
          ),
        ).called(1);
      });
    });

    group('getAllProducts', () {
      test('should return a list of products', () async {
        // Arrange
        when(
          () => mockDatabaseService.getAllData(BackendEndpoints.getAllProducts),
        ).thenAnswer((_) async => tProductsData);
        // Act
        final result = await sut.getAllProducts();
        // Assert
        expect(result, isA<NetworkSuccess<List<FruitEntity>>>());
        final successResult = result as NetworkSuccess<List<FruitEntity>>;
        expect(successResult.data!.length, 1);
        expect(successResult.data!.first.code, '123');
        expect(successResult.data!.first.name, 'Apple');
        verify(
          () => mockDatabaseService.getAllData(BackendEndpoints.getAllProducts),
        ).called(1);
      });

      test(
        'should return NetworkFailure when database throws FirebaseException',
        () async {
          // Arrange
          when(
            () =>
                mockDatabaseService.getAllData(BackendEndpoints.getAllProducts),
          ).thenThrow(FirebaseException(plugin: 'firestore', message: 'Error'));
          // Act
          final result = await sut.getAllProducts();
          // Assert
          expect(result, isA<NetworkFailure<List<FruitEntity>>>());
          verify(
            () =>
                mockDatabaseService.getAllData(BackendEndpoints.getAllProducts),
          ).called(1);
        },
      );

      test(
        'should return NetworkFailure when database throws Generic Exception',
        () async {
          // Arrange
          when(
            () =>
                mockDatabaseService.getAllData(BackendEndpoints.getAllProducts),
          ).thenThrow(Exception('Generic error'));
          // Act
          final result = await sut.getAllProducts();
          // Assert
          expect(result, isA<NetworkFailure<List<FruitEntity>>>());
          verify(
            () =>
                mockDatabaseService.getAllData(BackendEndpoints.getAllProducts),
          ).called(1);
        },
      );
    });

    group('deleteProduct', () {
      test('should delete product successfully', () async {
        // Arrange
        when(
          () => mockStorageService.deleteFolder(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode',
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockDatabaseService.deleteData(
            path: BackendEndpoints.deleteProduct,
            documentId: tCode,
          ),
        ).thenAnswer((_) async {});
        // Act
        final result = await sut.deleteProduct(tCode);
        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockStorageService.deleteFolder(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode',
          ),
        ).called(1);
        verify(
          () => mockDatabaseService.deleteData(
            path: BackendEndpoints.deleteProduct,
            documentId: tCode,
          ),
        ).called(1);
      });
      test('should return NetworkFailure if storage deletion fails', () async {
        // Arrange
        when(
          () => mockStorageService.deleteFolder(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode',
          ),
        ).thenThrow(Exception('Storage error'));
        // Act
        final result = await sut.deleteProduct(tCode);
        // Assert
        expect(result, isA<NetworkFailure<void>>());
        verify(
          () => mockStorageService.deleteFolder(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode',
          ),
        ).called(1);
        verifyNever(
          () => mockDatabaseService.deleteData(
            path: BackendEndpoints.deleteProduct,
            documentId: tCode,
          ),
        );
      });
      test('should return NetworkFailure if database deletion fails', () async {
        // Arrange
        when(
          () => mockStorageService.deleteFolder(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode',
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockDatabaseService.deleteData(
            path: BackendEndpoints.deleteProduct,
            documentId: tCode,
          ),
        ).thenThrow(Exception('Database error'));
        // Act
        final result = await sut.deleteProduct(tCode);
        // Assert
        expect(result, isA<NetworkFailure<void>>());
        verify(
          () => mockStorageService.deleteFolder(
            bucketName: BackendEndpoints.bucketName,
            path: 'images/$tCode',
          ),
        ).called(1);
        verify(
          () => mockDatabaseService.deleteData(
            path: BackendEndpoints.deleteProduct,
            documentId: tCode,
          ),
        ).called(1);
      });
    });

    group('updateProduct', () {
      const tFruitEntityNoImage = FruitEntity(
        code: tCode,
        name: 'Updated Name',
        price: 150,
        image: null,
      );
      test(
        'should upload new image and update data when image is provided',
        () async {
          // Arrange
          when(
            () => mockStorageService.deleteFolder(
              bucketName: any(named: 'bucketName'),
              path: any(named: 'path'),
            ),
          ).thenAnswer((_) async {});
          when(
            () => mockStorageService.uploadFile(
              bucketName: any(named: 'bucketName'),
              data: any(named: 'data'),
              path: any(named: 'path'),
            ),
          ).thenAnswer((_) async => tDownloadUrl);
          when(
            () => mockDatabaseService.updateData(
              path: any(named: 'path'),
              documentId: any(named: 'documentId'),
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async {});
          // Act
          final result = await sut.updateProduct(tFruitEntity);
          // Assert
          expect(result, isA<NetworkSuccess<void>>());
          verify(
            () => mockStorageService.deleteFolder(
              bucketName: any(named: 'bucketName'),
              path: any(named: 'path'),
            ),
          ).called(1);
          verify(
            () => mockStorageService.uploadFile(
              bucketName: any(named: 'bucketName'),
              data: any(named: 'data'),
              path: any(named: 'path'),
            ),
          ).called(1);
          verify(
            () => mockDatabaseService.updateData(
              path: any(named: 'path'),
              documentId: any(named: 'documentId'),
              data: any(named: 'data'),
            ),
          ).called(1);
        },
      );
      test('should ONLY update database when no image is provided', () async {
        // Arrange
        when(
          () => mockDatabaseService.updateData(
            path: any(named: 'path'),
            data: any(named: 'data'),
            documentId: any(named: 'documentId'),
          ),
        ).thenAnswer((_) async {});
        // Act
        final result = await sut.updateProduct(tFruitEntityNoImage);
        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verifyNever(
          () => mockStorageService.deleteFolder(
            bucketName: any(named: 'bucketName'),
            path: any(named: 'path'),
          ),
        );
        verifyNever(
          () => mockStorageService.uploadFile(
            bucketName: any(named: 'bucketName'),
            data: any(named: 'data'),
            path: any(named: 'path'),
          ),
        );
        verify(
          () => mockDatabaseService.updateData(
            path: any(named: 'path'),
            data: any(named: 'data'),
            documentId: any(named: 'documentId'),
          ),
        );
      });
      test('should return NetworkFailure when deleteFolder fails', () async {
        // Arrange
        when(
          () => mockStorageService.deleteFolder(
            path: any(named: 'path'),
            bucketName: any(named: 'bucketName'),
          ),
        ).thenThrow(Exception('Storage error'));
        // Act
        final result = await sut.updateProduct(tFruitEntity);
        // Assert
        expect(result, isA<NetworkFailure<void>>());
        verify(
          () => mockStorageService.deleteFolder(
            path: any(named: 'path'),
            bucketName: any(named: 'bucketName'),
          ),
        ).called(1);
        verifyNever(
          () => mockStorageService.uploadFile(
            bucketName: any(named: 'bucketName'),
            data: any(named: 'data'),
            path: any(named: 'path'),
          ),
        );
        verifyNever(
          () => mockDatabaseService.updateData(
            path: any(named: 'path'),
            data: any(named: 'data'),
            documentId: any(named: 'documentId'),
          ),
        );
      });
      test('should return NetworkFailure when uploadFile fails', () async {
        // Arrange
        when(
          () => mockStorageService.deleteFolder(
            bucketName: any(named: 'bucketName'),
            path: any(named: 'path'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockStorageService.uploadFile(
            bucketName: any(named: 'bucketName'),
            data: any(named: 'data'),
            path: any(named: 'path'),
          ),
        ).thenThrow(Exception('Storage error'));
        // Act
        final result = await sut.updateProduct(tFruitEntity);
        // Assert
        expect(result, isA<NetworkFailure<void>>());
        verify(
          () => mockStorageService.deleteFolder(
            bucketName: any(named: 'bucketName'),
            path: any(named: 'path'),
          ),
        ).called(1);
        verify(
          () => mockStorageService.uploadFile(
            bucketName: any(named: 'bucketName'),
            data: any(named: 'data'),
            path: any(named: 'path'),
          ),
        ).called(1);
        verifyNever(
          () => mockDatabaseService.updateData(
            path: any(named: 'path'),
            data: any(named: 'data'),
            documentId: any(named: 'documentId'),
          ),
        );
      });
      test('should return NetworkFailure when updateData fails', () async {
        // Arrange
        when(
          () => mockStorageService.deleteFolder(
            bucketName: any(named: 'bucketName'),
            path: any(named: 'path'),
          ),
        ).thenAnswer((_) async {});

        when(
          () => mockStorageService.uploadFile(
            bucketName: any(named: 'bucketName'),
            path: any(named: 'path'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => 'url');
        when(
          () => mockDatabaseService.updateData(
            path: any(named: 'path'),
            data: any(named: 'data'),
            documentId: any(named: 'documentId'),
          ),
        ).thenThrow(Exception('Database error'));
        // Act
        final result = await sut.updateProduct(tFruitEntity);
        // Assert
        expect(result, isA<NetworkFailure<void>>());
        verify(
          () => mockStorageService.deleteFolder(
            bucketName: any(named: 'bucketName'),
            path: any(named: 'path'),
          ),
        ).called(1);
        verify(
          () => mockStorageService.uploadFile(
            bucketName: any(named: 'bucketName'),
            data: any(named: 'data'),
            path: any(named: 'path'),
          ),
        ).called(1);
        verify(
          () => mockDatabaseService.updateData(
            path: any(named: 'path'),
            data: any(named: 'data'),
            documentId: any(named: 'documentId'),
          ),
        ).called(1);
      });
    });
  });
}
