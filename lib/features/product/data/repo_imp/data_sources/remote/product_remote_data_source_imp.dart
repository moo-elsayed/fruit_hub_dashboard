import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fruit_hub_dashboard/core/helpers/functions.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/product/data/firebase/product_firebase.dart';
import 'package:fruit_hub_dashboard/features/product/data/models/fruit_model.dart';
import 'package:fruit_hub_dashboard/features/product/data/supabase/product_supabase.dart';
import '../../../../domain/entities/fruit_entity.dart';
import '../../../../domain/repo_contarct/data_sources/remote/product_remote_data_source.dart';

class ProductRemoteDataSourceImp implements ProductRemoteDataSource {
  ProductRemoteDataSourceImp(this._productSupabase, this._productFirebase);

  final ProductSupabase _productSupabase;
  final ProductFirebase _productFirebase;

  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) async {
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      fruitEntity.image!.path,
      quality: 60,
      format: CompressFormat.jpeg,
    );
    var networkResponse = await _productSupabase.uploadImage(
      file: fruitEntity.image!,
      path: 'images/${fruitEntity.image!.name}',
      imageBytes: compressedBytes,
    );
    switch (networkResponse) {
      case NetworkSuccess<String>():
        final imageUrl = networkResponse.data;
        try {
          fruitEntity.imagePath = imageUrl!;
          await _productFirebase.addProduct(FruitModel.fromEntity(fruitEntity));
          return NetworkSuccess(imageUrl);
        } catch (e) {
          errorLogger(
            functionName: 'ProductRemoteDataSourceImp.addProduct',
            error: e.toString(),
          );
          await _productSupabase.deleteImage(
            imageUrl: imageUrl!,
            buketName: 'products',
            pathToPhoto: 'products/images',
          );
          return NetworkFailure(Exception(e.toString()));
        }
      case NetworkFailure<String>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
