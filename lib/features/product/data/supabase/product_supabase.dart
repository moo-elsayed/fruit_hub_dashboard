import 'package:flutter/foundation.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import '../../../../core/helpers/functions.dart';

class ProductSupabase {
  ProductSupabase(this._storageService);

  final StorageService _storageService;

  Future<NetworkResponse<String>> uploadImage({
    required String bucketName,
    required String path,
    required Uint8List? imageBytes,
  }) async {
    try {
      var imageUrl = await _storageService.uploadFile(
        bucketName: bucketName,
        path: path,
        imageBytes: imageBytes,
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
      await _storageService.deleteFile(
        bucketName: bucketName,
        path: path,
      );
      return NetworkSuccess();
    } catch (e) {
      return NetworkFailure(Exception(e.toString()));
    }
  }
}
