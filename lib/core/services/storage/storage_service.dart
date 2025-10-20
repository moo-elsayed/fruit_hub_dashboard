import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

abstract class StorageService {
  Future<String> uploadFile({
    required String bucketName,
    required String path,
    required Uint8List data,
  });

  Future<String> uploadCompressedImage({
    required String bucketName,
    required String path,
    required XFile image,
    CompressFormat compressFormat = CompressFormat.png,
    int quality = 60,
  });

  Future<void> deleteFile({required String bucketName, required String path});
}
