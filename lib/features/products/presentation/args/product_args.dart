import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:image_picker/image_picker.dart';

class ProductArgs {
  ProductArgs()
    : formKey = GlobalKey<FormState>(),
      nameController = TextEditingController(),
      priceController = TextEditingController(),
      codeController = TextEditingController(),
      descriptionController = TextEditingController(),
      caloriesController = TextEditingController(),
      weightInGramsController = TextEditingController(),
      daysUntilExpirationController = TextEditingController(),
      imageController = TextEditingController();

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final TextEditingController caloriesController;
  final TextEditingController weightInGramsController;
  final TextEditingController daysUntilExpirationController;
  final TextEditingController imageController;

  FruitEntity? originalFruit;
  bool isFeatured = false;
  bool isOrganic = false;
  bool isEditMode = false;

  bool get isValid => formKey.currentState!.validate();

  bool get hasChanges {
    if (originalFruit == null) return true;
    final current = toEntity();
    final original = originalFruit!;
    final originalWeight = original.weightInGrams > 0
        ? original.weightInGrams
        : 1000;
    return current.name != original.name ||
        current.price != original.price ||
        current.code != original.code ||
        current.description != original.description ||
        current.isFeatured != original.isFeatured ||
        current.isOrganic != original.isOrganic ||
        current.daysUntilExpiration != original.daysUntilExpiration ||
        current.numberOfCalories != original.numberOfCalories ||
        current.weightInGrams != originalWeight ||
        imageController.text.trim() != original.imagePath;
  }

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    caloriesController.dispose();
    weightInGramsController.dispose();
    daysUntilExpirationController.dispose();
    imageController.dispose();
  }

  void setValues(FruitEntity fruit) {
    originalFruit = fruit;
    nameController.text = fruit.name;
    priceController.text = fruit.price.toString();
    codeController.text = fruit.code;
    descriptionController.text = fruit.description;
    caloriesController.text = fruit.numberOfCalories.toString();
    weightInGramsController.text =
        (fruit.weightInGrams > 0 ? fruit.weightInGrams : 1000).toString();
    daysUntilExpirationController.text = fruit.daysUntilExpiration.toString();
    imageController.text = fruit.imagePath;

    isFeatured = fruit.isFeatured;
    isOrganic = fruit.isOrganic;
    isEditMode = true;
  }

  FruitEntity toEntity() {
    final path = imageController.text.trim();
    final isRemote = path.startsWith('http');
    XFile? localImage;
    if (path.isNotEmpty && !isRemote) {
      localImage = XFile(path);
    }

    return FruitEntity(
      name: nameController.text.trim(),
      price: double.tryParse(priceController.text.trim()) ?? 0,
      code: codeController.text.trim(),
      description: descriptionController.text.trim(),
      isFeatured: isFeatured,
      isOrganic: isOrganic,
      imagePath: isRemote ? path : '',
      image: localImage,
      numberOfCalories: int.tryParse(caloriesController.text.trim()) ?? 0,
      weightInGrams: int.tryParse(weightInGramsController.text.trim()) ?? 0,
      daysUntilExpiration:
          int.tryParse(daysUntilExpirationController.text.trim()) ?? 0,
      ratingCount: originalFruit?.ratingCount ?? 0,
      avgRating: originalFruit?.avgRating ?? 0,
      reviews: originalFruit?.reviews ?? const [],
    );
  }
}
