import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';

class ProductArgs {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController unitAmountController = TextEditingController();
  final TextEditingController daysUntilExpirationController =
      TextEditingController();

  bool isFeatured = false;
  bool isOrganic = false;
  XFile? image;
  String? imageUrl;

  bool get isValid => formKey.currentState!.validate();

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    caloriesController.dispose();
    unitAmountController.dispose();
    daysUntilExpirationController.dispose();
  }

  void setValues(FruitEntity fruit) {
    nameController.text = fruit.name;
    priceController.text = fruit.price.toString();
    codeController.text = fruit.code;
    descriptionController.text = fruit.description;
    caloriesController.text = fruit.numberOfCalories.toString();
    unitAmountController.text = fruit.unitAmount.toString();
    daysUntilExpirationController.text = fruit.daysUntilExpiration.toString();

    isFeatured = fruit.isFeatured;
    isOrganic = fruit.isOrganic;
    imageUrl = fruit.imagePath;
  }

  FruitEntity toEntity() => FruitEntity(
    name: nameController.text,
    price: double.tryParse(priceController.text) ?? 0,
    code: codeController.text,
    description: descriptionController.text,
    isFeatured: isFeatured,
    isOrganic: isOrganic,
    imagePath: imageUrl ?? '',
    image: image,
    numberOfCalories: int.tryParse(caloriesController.text) ?? 0,
    unitAmount: int.tryParse(unitAmountController.text) ?? 0,
    daysUntilExpiration: int.tryParse(daysUntilExpirationController.text) ?? 0,
  );
}
