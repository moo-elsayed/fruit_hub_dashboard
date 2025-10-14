import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/helpers/functions.dart';

class ProductSupabase {
  final Supabase _supabase = Supabase.instance;

  Future<NetworkResponse<String>> uploadImage({
    required XFile file,
    required String path,
    required Uint8List? imageBytes,
  }) async {
    try {
      await _supabase.client.storage
          .from('products')
          .uploadBinary(
            path,
            imageBytes!,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = _supabase.client.storage
          .from('products')
          .getPublicUrl(path);

      return NetworkSuccess(publicUrl);
    } catch (e) {
      errorLogger(
        functionName: 'ProductSupabase.addProduct',
        error: e.toString(),
      );
      return NetworkFailure(Exception(e.toString()));
    }
  }

  Future<void> deleteImage({
    required String imageUrl,
    required String buketName,
    required String pathToPhoto,
  }) async {
    final existingFiles = await Supabase.instance.client.storage
        .from(buketName)
        .list(path: '$pathToPhoto/');

    for (var file in existingFiles) {
      log(Uri.parse(imageUrl).pathSegments.last);
      log(file.name);
      if (file.name == Uri.parse(imageUrl).pathSegments.last) {
        await Supabase.instance.client.storage.from(buketName).remove([
          '$pathToPhoto/${file.name}',
        ]);
        log("removed");
        break;
      }
    }
  }
}
