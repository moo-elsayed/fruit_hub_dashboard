import 'dart:typed_data';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements StorageService {
  final Supabase _supabase = Supabase.instance;

  @override
  Future<String> uploadFile({
    required String bucketName,
    required String path,
    required Uint8List? imageBytes,
  }) async {
    await _supabase.client.storage
        .from(bucketName)
        .uploadBinary(
          path,
          imageBytes!,
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
  }) async => await Supabase.instance.client.storage.from(bucketName).remove([
    path,
  ]);
}
