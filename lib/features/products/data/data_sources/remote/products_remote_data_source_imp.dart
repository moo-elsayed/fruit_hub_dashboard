import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fruit_hub_dashboard/core/errors/exceptions.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/helpers/image_compressor.dart';
import 'package:fruit_hub_dashboard/core/network/api_helper.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/products/data/models/fruit_model.dart';

class ProductsRemoteDataSourceImp implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImp({
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
    ImageCompressor? imageCompressor,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = firebaseStorage ?? FirebaseStorage.instance,
       _imageCompressor = imageCompressor ?? ImageCompressor();

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImageCompressor _imageCompressor;

  @override
  Future<NetworkResponse<void>> addProduct(
    FruitModel fruitModel, {
    Uint8List? imageBytes,
    String? imageName,
  }) async => ApiHelper.executeSafely(() async {
    final docRef = _firestore
        .collection(BackendEndpoints.productsCollection)
        .doc(fruitModel.code);

    final docSnap = await docRef.get();
    if (docSnap.exists) {
      throw BusinessException('Product with this code already exists');
    }

    String? imageUrl;
    if (imageBytes != null && imageName != null) {
      final compressedBytes = await _imageCompressor.compressImage(imageBytes);
      final ref = _storage.ref().child('images/${fruitModel.code}/$imageName');
      await ref.putData(compressedBytes);
      imageUrl = await ref.getDownloadURL();
    }

    final modelToSave = fruitModel.copyWith(imagePath: imageUrl);
    await docRef.set(modelToSave.toJson());
  }, functionName: 'addProduct');

  @override
  Future<NetworkResponse<List<FruitModel>>> getAllProducts() async =>
      ApiHelper.executeSafely(() async {
        final querySnapshot = await _firestore
            .collection(BackendEndpoints.productsCollection)
            .get();

        return querySnapshot.docs
            .map((doc) => FruitModel.fromJson(doc.data()))
            .toList();
      }, functionName: 'getAllProducts');

  @override
  Future<NetworkResponse<void>> deleteProduct(String code) async =>
      ApiHelper.executeSafely(() async {
        try {
          final listResult = await _storage
              .ref()
              .child('images/$code')
              .listAll();
          for (final item in listResult.items) {
            await item.delete();
          }
        } catch (_) {}

        await _firestore
            .collection(BackendEndpoints.productsCollection)
            .doc(code)
            .delete();
      }, functionName: 'deleteProduct');

  @override
  Future<NetworkResponse<void>> updateProduct(
    FruitModel fruitModel, {
    Uint8List? imageBytes,
    String? imageName,
  }) async => ApiHelper.executeSafely(() async {
    String? imageUrl;
    if (imageBytes != null && imageName != null) {
      try {
        final listResult = await _storage
            .ref()
            .child('images/${fruitModel.code}')
            .listAll();
        for (final item in listResult.items) {
          await item.delete();
        }
      } catch (_) {}

      final compressedBytes = await _imageCompressor.compressImage(imageBytes);
      final ref = _storage.ref().child('images/${fruitModel.code}/$imageName');
      await ref.putData(compressedBytes);
      imageUrl = await ref.getDownloadURL();
    }

    final modelToSave = fruitModel.copyWith(
      imagePath: imageUrl ?? fruitModel.imagePath,
    );
    await _firestore
        .collection(BackendEndpoints.productsCollection)
        .doc(modelToSave.code)
        .update(modelToSave.toJson());
  }, functionName: 'updateProduct');
}
