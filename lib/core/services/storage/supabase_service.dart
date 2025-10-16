import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements StorageService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

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
    int quality = 60,
  }) async {
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      image.path,
      quality: quality,
      format: CompressFormat.jpeg,
    );

    if (compressedBytes == null) {
      throw Exception("Image compression failed.");
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
}
