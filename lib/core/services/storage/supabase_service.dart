import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements StorageService {
  final Supabase _supabase = Supabase.instance;

  @override
  Future<String> uploadImage({
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

    await _supabase.client.storage
        .from(bucketName)
        .uploadBinary(
          path,
          compressedBytes!,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _supabase.client.storage
        .from(bucketName)
        .getPublicUrl(path);

    return publicUrl;
  }

  @override
  Future<void> deleteFile({
    required String bucketName,
    required String path,
  }) async =>
      await Supabase.instance.client.storage.from(bucketName).remove([path]);
}
