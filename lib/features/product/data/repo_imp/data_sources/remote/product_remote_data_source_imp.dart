import 'package:firebase_core/firebase_core.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:fruit_hub_dashboard/features/product/data/models/fruit_model.dart';
import '../../../../../../core/helpers/backend_endpoints.dart';
import '../../../../../../core/helpers/failures.dart';
import '../../../../../../core/helpers/functions.dart';
import '../../../../domain/entities/fruit_entity.dart';
import '../../../../domain/repo_contarct/data_sources/remote/product_remote_data_source.dart';

class ProductRemoteDataSourceImp implements ProductRemoteDataSource {
  final DatabaseService _databaseService;
  final StorageService _storageService;

  ProductRemoteDataSourceImp(this._databaseService, this._storageService);

  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) async {
    if (await _checkIfProductExists(fruitEntity.code)) {
      return NetworkFailure(Exception('Product with this code already exists'));
    }

    final imagePath = 'images/${fruitEntity.code}/${fruitEntity.image!.name}';
    String? imageUrl;

    try {
      imageUrl = await _storageService.uploadCompressedImage(
        bucketName: BackendEndpoints.bucketName,
        path: imagePath,
        image: fruitEntity.image!,
      );

      final fruitModel = FruitModel.fromEntity(fruitEntity)
        ..imagePath = imageUrl;
      await _databaseService.addData(
        path: BackendEndpoints.addProduct,
        data: fruitModel.toJson(),
        docId: fruitModel.code,
      );

      return NetworkSuccess();
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
        errorMessage: "Failed to add product: ${e.toString()}",
      );
    }
  }

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
    errorLogger(
      functionName: 'ProductDataSource.addProduct',
      error: e.toString(),
    );
    if (imageUrl != null) {
      await _storageService.deleteFile(
        bucketName: BackendEndpoints.bucketName,
        path: imagePath,
      );
    }
    return NetworkFailure(Exception(errorMessage));
  }
}
