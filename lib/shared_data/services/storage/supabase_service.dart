import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_logger.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/helpers/image_compressor.dart';

class SupabaseService implements StorageService {
  SupabaseService(this._supabaseClient, this._imageCompressor);

  final SupabaseClient _supabaseClient;
  final ImageCompressor _imageCompressor;

  @override
  Future<String> uploadFile({
    required String bucketName,
    required String path,
    required Uint8List data,
  }) async {
    await _supabaseClient.storage
        .from(bucketName)
        .uploadBinary(path, data, fileOptions: const FileOptions(upsert: true));

    return _supabaseClient.storage.from(bucketName).getPublicUrl(path);
  }

  @override
  Future<String> uploadCompressedImage({
    required String bucketName,
    required String path,
    required XFile image,
    CompressFormat compressFormat = CompressFormat.png,
    int quality = 60,
  }) async {
    final compressedBytes = await _imageCompressor.compressWithFile(
      image.path,
      quality: quality,
      format: compressFormat,
    );

    if (compressedBytes == null) {
      AppLogger.error(
        'SupabaseService.uploadCompressedImage',
        error:
            'Failed to compress image at path: ${image.path}. The result was null.',
      );
      const String error =
          "Couldn't upload image. Please try again or choose a different one.";
      throw Exception(error);
    }

    return await uploadFile(
      bucketName: bucketName,
      path: path,
      data: compressedBytes,
    );
  }

  @override
  Future<void> deleteFile({
    required String bucketName,
    required String path,
  }) async => await _supabaseClient.storage.from(bucketName).remove([path]);

  @override
  Future<void> deleteFolder({
    required String bucketName,
    required String path,
  }) async {
    final files = await _supabaseClient.storage
        .from(bucketName)
        .list(path: path);
    if (files.isEmpty) return;
    final pathsToDelete = files.map((file) => '$path/${file.name}').toList();
    await _supabaseClient.storage.from(bucketName).remove(pathsToDelete);
  }
}
