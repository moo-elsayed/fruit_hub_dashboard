import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  Future<Uint8List?> compressWithFile(
    String path, {
    int quality = 60,
    CompressFormat format = CompressFormat.png,
  }) async => await FlutterImageCompress.compressWithFile(
    path,
    quality: quality,
    format: format,
  );
}
