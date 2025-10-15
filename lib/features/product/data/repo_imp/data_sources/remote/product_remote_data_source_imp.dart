import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/product/data/firebase/product_firebase.dart';
import 'package:fruit_hub_dashboard/features/product/data/models/fruit_model.dart';
import 'package:fruit_hub_dashboard/features/product/data/supabase/product_supabase.dart';
import '../../../../../../core/helpers/backend_endpoints.dart';
import '../../../../domain/entities/fruit_entity.dart';
import '../../../../domain/repo_contarct/data_sources/remote/product_remote_data_source.dart';

class ProductRemoteDataSourceImp implements ProductRemoteDataSource {
  ProductRemoteDataSourceImp(this._productSupabase, this._productFirebase);

  final ProductSupabase _productSupabase;
  final ProductFirebase _productFirebase;

  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) async {
    String path = 'images/${fruitEntity.code}/${fruitEntity.image!.name}';
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      fruitEntity.image!.path,
      quality: 60,
      format: CompressFormat.jpeg,
    );
    var networkResponse = await _productSupabase.uploadImage(
      bucketName: BackendEndpoints.uploadImage,
      path: path,
      imageBytes: compressedBytes,
    );
    switch (networkResponse) {
      case NetworkSuccess<String>():
        final imageUrl = networkResponse.data;
        fruitEntity.imagePath = imageUrl!;
        var networkResponse2 = await _productFirebase.addProduct(
          FruitModel.fromEntity(fruitEntity),
        );
        switch (networkResponse2) {
          case NetworkSuccess():
            return NetworkSuccess();
          case NetworkFailure():
            var networkResponse3 = await _productSupabase.deleteImage(
              bucketName: 'products',
              path: path,
            );
            switch (networkResponse3) {
              case NetworkSuccess():
                return NetworkFailure(networkResponse2.exception);
              case NetworkFailure():
                return NetworkFailure(networkResponse3.exception);
            }
        }
      case NetworkFailure<String>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
