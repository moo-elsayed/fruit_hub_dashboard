import 'dart:typed_data';

abstract class StorageService {
  Future<String> uploadFile({
    required String bucketName,
    required String path,
    required Uint8List? imageBytes,
  });

  Future<void> deleteFile({
    required String bucketName,
    required String path,
  });
}
