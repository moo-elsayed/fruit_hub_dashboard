import 'dart:typed_data';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import '../../models/fruit_model.dart';

abstract class ProductsRemoteDataSource {
  Future<NetworkResponse<List<FruitModel>>> getAllProducts();

  Future<NetworkResponse<void>> addProduct(
    FruitModel fruitModel, {
    Uint8List? imageBytes,
    String? imageName,
  });

  Future<NetworkResponse<void>> deleteProduct(String code);

  Future<NetworkResponse<void>> updateProduct(
    FruitModel fruitModel, {
    Uint8List? imageBytes,
    String? imageName,
  });
}
