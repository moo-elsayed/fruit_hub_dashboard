import 'package:firebase_core/firebase_core.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_logger.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source.dart';
import '../../../../../../core/helpers/backend_endpoints.dart';
import '../../../../../../core/helpers/failures.dart';
import '../../../domain/entities/fruit_entity.dart';
import '../../models/fruit_model.dart';

class ProductsRemoteDataSourceImp implements ProductsRemoteDataSource {
  final DatabaseService _databaseService;
  final StorageService _storageService;

  ProductsRemoteDataSourceImp(this._databaseService, this._storageService);

  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) async {
    if (await _checkIfProductExists(fruitEntity.code)) {
      return NetworkFailure(Exception('Product with this code already exists'));
    }

    final imagePath = 'images/${fruitEntity.code}/${fruitEntity.image!.name}';
    String? imageUrl;

    try {
      imageUrl = await _storageService.uploadFile(
        bucketName: BackendEndpoints.bucketName,
        path: imagePath,
        data: await fruitEntity.image!.readAsBytes(),
      );

      var fruitModel = FruitModel.fromEntity(fruitEntity);
      fruitModel = fruitModel.copyWith(imagePath: imageUrl);
      await _databaseService.addData(
        path: BackendEndpoints.addProduct,
        data: fruitModel.toJson(),
        docId: fruitModel.code,
      );

      return const NetworkSuccess();
    } on FirebaseException catch (e) {
      return await _handelAddProductError(
        e: e,
        imageUrl: imageUrl,
        imagePath: imagePath,
        errorMessage: ServerFailure.fromFirebaseException(e).errorMessage,
      );
    } catch (e) {
      return await _handelAddProductError(
        e: e,
        imageUrl: imageUrl,
        imagePath: imagePath,
        errorMessage: "Failed to add products: ${e.toString()}",
      );
    }
  }

  @override
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts() async {
    try {
      final response = await _databaseService.getAllData(
        BackendEndpoints.getAllProducts,
      );

      final List<FruitEntity> fruits = response
          .map((e) => FruitModel.fromJson(e).toEntity())
          .toList();

      return NetworkSuccess(fruits);
    } on FirebaseException catch (e) {
      _logError(e: e);
      return NetworkFailure(
        Exception(ServerFailure.fromFirebaseException(e).errorMessage),
      );
    } catch (e) {
      _logError(e: e);
      return NetworkFailure(Exception(e.toString()));
    }
  }

  // -------------------------------------------------------------------
  // Private Helper Methods
  // -------------------------------------------------------------------

  void _logError({
    required Object e,
    String functionName = "ProductRemoteDataSourceImp.getAllProducts",
  }) => AppLogger.error("error occurred in $functionName", error: e.toString());

  Future<bool> _checkIfProductExists(String code) async {
    return await _databaseService.checkIfDataExists(
      path: BackendEndpoints.checkIfProductExists,
      documentId: code,
    );
  }

  Future<NetworkFailure> _handelAddProductError({
    required Object e,
    required String imagePath,
    required String errorMessage,
    String? imageUrl,
  }) async {
    AppLogger.error('error occurred in addProduct', error: e.toString());
    if (imageUrl != null) {
      await _storageService.deleteFile(
        bucketName: BackendEndpoints.bucketName,
        path: imagePath,
      );
    }
    return NetworkFailure(Exception(errorMessage));
  }
}
