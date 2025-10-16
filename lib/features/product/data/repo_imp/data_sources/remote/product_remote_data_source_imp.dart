import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/features/product/data/firebase/product_firebase.dart';
import 'package:fruit_hub_dashboard/features/product/data/models/fruit_model.dart';
import 'package:fruit_hub_dashboard/features/product/data/supabase/product_supabase.dart';
import '../../../../../../core/helpers/backend_endpoints.dart';
import '../../../../domain/entities/fruit_entity.dart';
import '../../../../domain/repo_contarct/data_sources/remote/product_remote_data_source.dart';

class ProductRemoteDataSourceImp implements ProductRemoteDataSource {
  ProductRemoteDataSourceImp(
    this._productSupabase,
    this._productFirebase,
    this._databaseService,
  );

  final ProductSupabase _productSupabase;
  final ProductFirebase _productFirebase;
  final DatabaseService _databaseService;

  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) async {
    String path = 'images/${fruitEntity.code}/${fruitEntity.image!.name}';

    if (await _checkIfProductExists(fruitEntity.code)) {
      return NetworkFailure(Exception('Product with this code already exists'));
    }

    var networkResponse = await _productSupabase.uploadImage(
      bucketName: BackendEndpoints.uploadImage,
      path: path,
      image: fruitEntity.image!,
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

  Future<bool> _checkIfProductExists(String code) async =>
      await _databaseService.checkIfDataExists(
        path: BackendEndpoints.checkIfProductExists,
        documentId: code,
      );
}
