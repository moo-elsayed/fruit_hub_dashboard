import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/fruit_entity.dart';

class GetProductsUseCase {
  GetProductsUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<NetworkResponse<List<FruitEntity>>> call() async =>
      await _productsRepo.getAllProducts();
}
