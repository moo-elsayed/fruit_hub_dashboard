import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import '../../../../core/helpers/functions.dart';

class ProductSupabase {
  ProductSupabase(this._storageService);

  final StorageService _storageService;

  Future<NetworkResponse<String>> uploadImage({
    required String bucketName,
    required String path,
    required XFile image,
    int quality = 60,
  }) async {
    try {
      var imageUrl = await _storageService.uploadImage(
        bucketName: bucketName,
        image: image,
        path: path,
        quality: quality,
      );
      return NetworkSuccess(imageUrl);
    } catch (e) {
      errorLogger(
        functionName: 'ProductSupabase.addProduct',
        error: e.toString(),
      );
      return NetworkFailure(Exception(e.toString()));
    }
  }

  Future<NetworkResponse> deleteImage({
    required String bucketName,
    required String path,
  }) async {
    try {
      await _storageService.deleteFile(bucketName: bucketName, path: path);
      return NetworkSuccess();
    } catch (e) {
      return NetworkFailure(Exception(e.toString()));
    }
  }
}
