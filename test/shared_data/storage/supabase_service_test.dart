import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/image_compressor.dart';
import 'package:fruit_hub_dashboard/shared_data/services/storage/supabase_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseStorageClient extends Mock implements SupabaseStorageClient {}

class MockStorageFileApi extends Mock implements StorageFileApi {}

class MockImageCompressor extends Mock implements ImageCompressor {}

void main() {
  late SupabaseService sut;
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseStorageClient mockStorageClient;
  late MockStorageFileApi mockStorageFileApi;
  late MockImageCompressor mockImageCompressor;

  const tBucketName = 'products';
  const tPath = 'images/test.png';
  const tLength = 64;
  final tData = Uint8List.fromList([1, 2, 3]);
  final tCompressedData = Uint8List.fromList([4, 5, 6]);
  final tImage = XFile('path/to/image.png');
  final tFiles = [
    const FileObject(
      name: 'image1.png',
      bucketId: '',
      owner: '',
      id: '',
      updatedAt: '',
      createdAt: '',
      lastAccessedAt: '',
      metadata: {},
      buckets: null,
    ),
    const FileObject(
      name: 'image2.jpg',
      bucketId: '',
      owner: '',
      id: '',
      updatedAt: '',
      createdAt: '',
      lastAccessedAt: '',
      metadata: {},
      buckets: null,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(Uint8List(tLength));
    registerFallbackValue(const FileOptions(upsert: true));
    registerFallbackValue(CompressFormat.png);
  });

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockStorageClient = MockSupabaseStorageClient();
    mockStorageFileApi = MockStorageFileApi();
    mockImageCompressor = MockImageCompressor();
    sut = SupabaseService(mockSupabaseClient, mockImageCompressor);

    when(() => mockSupabaseClient.storage).thenReturn(mockStorageClient);
    when(() => mockStorageClient.from(any())).thenReturn(mockStorageFileApi);
  });

  group('SupabaseService', () {
    group('uploadFile', () {
      const tUrl =
          'https://supabase.co/storage/v1/object/public/products/images/test.png';
      test('uploadFile should upload binary and return public url', () async {
        // Arrange
        when(
          () => mockStorageFileApi.uploadBinary(
            any(),
            any(),
            fileOptions: any(named: 'fileOptions'),
          ),
        ).thenAnswer((_) async => 'path/to/file');
        when(() => mockStorageFileApi.getPublicUrl(any())).thenReturn(tUrl);
        // Act
        final result = await sut.uploadFile(
          bucketName: tBucketName,
          path: tPath,
          data: tData,
        );
        // Assert
        expect(result, tUrl);
        verify(
          () => mockStorageFileApi.uploadBinary(
            tPath,
            tData,
            fileOptions: const FileOptions(upsert: true),
          ),
        ).called(1);
      });
    });
    group('uploadCompressedImage', () {
      const tUrl =
          'https://supabase.co/storage/v1/object/public/products/images/test.png';
      test(
        'uploadCompressedImage should upload compressed image and return public url',
        () async {
          // Arrange
          when(
            () => mockImageCompressor.compressWithFile(
              any(),
              quality: any(named: 'quality'),
              format: any(named: 'format'),
            ),
          ).thenAnswer((_) async => tCompressedData);
          when(
            () => mockStorageFileApi.uploadBinary(
              any(),
              any(),
              fileOptions: any(named: 'fileOptions'),
            ),
          ).thenAnswer((_) async => 'path/to/file');
          when(() => mockStorageFileApi.getPublicUrl(any())).thenReturn(tUrl);
          // Act
          final result = await sut.uploadCompressedImage(
            bucketName: tBucketName,
            path: tPath,
            image: tImage,
          );
          // Assert
          expect(result, tUrl);
          verify(
            () => mockImageCompressor.compressWithFile(
              tImage.path,
              quality: 60,
              format: CompressFormat.png,
            ),
          ).called(1);
          verify(
            () => mockStorageFileApi.uploadBinary(
              tPath,
              tCompressedData,
              fileOptions: const FileOptions(upsert: true),
            ),
          ).called(1);
        },
      );
      test(
        'should throw Exception when compression fails (returns null)',
        () async {
          // Arrange
          when(
            () => mockImageCompressor.compressWithFile(any()),
          ).thenAnswer((_) async => null);
          // Act
          // Assert
          expect(
            () => sut.uploadCompressedImage(
              bucketName: tBucketName,
              path: tPath,
              image: tImage,
            ),
            throwsA(isA<Exception>()),
          );
          verifyNever(() => mockStorageFileApi.uploadBinary(any(), any()));
          verifyNever(() => mockStorageFileApi.getPublicUrl(any()));
        },
      );
    });
    group('deleteFile', () {
      test('deleteFile should remove file from storage', () async {
        // Arrange
        when(
          () => mockStorageFileApi.remove(any()),
        ).thenAnswer((_) async => []);
        // Act
        await sut.deleteFile(bucketName: tBucketName, path: tPath);
        // Assert
        verify(() => mockStorageFileApi.remove([tPath])).called(1);
      });
    });
    group('deleteFolder', () {
      const tFolderPath = 'images/product_123';
      test('should do nothing if folder is empty', () async {
        // Arrange
        when(
          () => mockStorageFileApi.list(path: any(named: 'path')),
        ).thenAnswer((_) async => []);
        // Act
        await sut.deleteFolder(bucketName: tBucketName, path: tFolderPath);
        // Assert
        verify(() => mockStorageFileApi.list(path: tFolderPath)).called(1);
        verifyNever(() => mockStorageFileApi.remove(any()));
      });
      test('should delete all files found in the folder', () async {
        // Arrange
        when(
          () => mockStorageFileApi.list(path: any(named: 'path')),
        ).thenAnswer((_) async => tFiles);
        when(
          () => mockStorageFileApi.remove(any()),
        ).thenAnswer((_) async => []);
        // Act
        await sut.deleteFolder(bucketName: tBucketName, path: tFolderPath);
        // Assert
        final expectedPaths = [
          '$tFolderPath/image1.png',
          '$tFolderPath/image2.jpg',
        ];
        verify(() => mockStorageFileApi.remove(expectedPaths)).called(1);
      });
    });
  });
}
