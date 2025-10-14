import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/product/data/models/fruit_model.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/services/database_service.dart';

class ProductFirebase {
  ProductFirebase(this._firestoreService);

  final DatabaseService _firestoreService;

  Future<NetworkResponse> addProduct(FruitModel fruit) async {
    try {
      await _firestoreService.addData(
        path: BackendEndpoints.addProduct,
        data: fruit.toJson(),
      );
      return NetworkSuccess();
    } catch (e) {
      errorLogger(
        functionName: 'ProductFirebase.addProduct',
        error: e.toString(),
      );
      return NetworkFailure(Exception(e.toString()));
    }
  }
}
