import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import '../../../../core/helpers/network_response.dart';

class DeleteProductUseCase {
  DeleteProductUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<NetworkResponse<void>> call(String code) =>
      _productsRepo.deleteProduct(code);
}
