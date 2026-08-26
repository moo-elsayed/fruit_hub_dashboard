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
      unitAmountController = TextEditingController(text: '1000'),
      daysUntilExpirationController = TextEditingController(),
      imageController = TextEditingController();

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final TextEditingController caloriesController;
  final TextEditingController unitAmountController;
  final TextEditingController daysUntilExpirationController;
  final TextEditingController imageController;

  bool isFeatured = false;
  bool isOrganic = false;
  bool isEditMode = false;

  bool get isValid => formKey.currentState!.validate();

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    caloriesController.dispose();
    unitAmountController.dispose();
    daysUntilExpirationController.dispose();
    imageController.dispose();
  }

  void setValues(FruitEntity fruit) {
    nameController.text = fruit.name;
    priceController.text = fruit.price.toString();
    codeController.text = fruit.code;
    descriptionController.text = fruit.description;
    caloriesController.text = fruit.numberOfCalories.toString();
    unitAmountController.text = (fruit.unitAmount > 0 ? fruit.unitAmount : 1000).toString();
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
      unitAmount: int.tryParse(unitAmountController.text.trim()) ?? 0,
      daysUntilExpiration:
          int.tryParse(daysUntilExpirationController.text.trim()) ?? 0,
    );
  }
}
