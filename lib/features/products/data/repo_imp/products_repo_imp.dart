import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/data/models/fruit_model.dart';

import '../../domain/entities/fruit_entity.dart';
import '../../domain/repo/products_repo.dart';
import '../data_sources/remote/products_remote_data_source.dart';

class ProductsRepoImp implements ProductsRepo {
  ProductsRepoImp(this._productsRemoteDataSource);

  final ProductsRemoteDataSource _productsRemoteDataSource;

  @override
  Future<NetworkResponse<void>> addProduct(FruitEntity fruitEntity) async {
    final model = FruitModel.fromEntity(fruitEntity);
    final imageBytes = fruitEntity.image != null
        ? await fruitEntity.image!.readAsBytes()
        : null;
    final imageName = fruitEntity.image?.name;
    return await _productsRemoteDataSource.addProduct(
      model,
      imageBytes: imageBytes,
      imageName: imageName,
    );
  }

  @override
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts() async {
    final response = await _productsRemoteDataSource.getAllProducts();
    switch (response) {
      case NetworkSuccess<List<FruitModel>>():
        return NetworkSuccess(
          response.data?.map((model) => model.toEntity()).toList(),
        );
      case NetworkFailure<List<FruitModel>>():
        return NetworkFailure(response.failure);
    }
  }

  @override
  Future<NetworkResponse<void>> deleteProduct(String code) async =>
      await _productsRemoteDataSource.deleteProduct(code);

  @override
  Future<NetworkResponse<void>> updateProduct(FruitEntity fruitEntity) async {
    final model = FruitModel.fromEntity(fruitEntity);
    final imageBytes = fruitEntity.image != null
        ? await fruitEntity.image!.readAsBytes()
        : null;
    final imageName = fruitEntity.image?.name;
    return await _productsRemoteDataSource.updateProduct(
      model,
      imageBytes: imageBytes,
      imageName: imageName,
    );
  }
}
