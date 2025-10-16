import 'package:flutter_image_compress/flutter_image_compress.dart';

abstract class StorageService {
  Future<String> uploadImage({
    required String bucketName,
    required String path,
    required XFile image,
    int quality = 60,
  });

  Future<void> deleteFile({required String bucketName, required String path});
}
