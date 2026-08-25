import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  Future<Uint8List> compressImage(
    Uint8List data, {
    int quality = 60,
    CompressFormat format = CompressFormat.png,
  }) async => await FlutterImageCompress.compressWithList(
    data,
    quality: quality,
    format: format,
  );

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
