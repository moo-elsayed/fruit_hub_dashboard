import 'package:image_picker/image_picker.dart';

class FruitEntity {
  FruitEntity({
    this.image,
    this.imagePath = '',
    this.name = '',
    this.code = '',
    this.description = '',
    this.price = 0,
    this.isFeatured = false,
  });

  final XFile? image;
  String imagePath;
  final String name;
  final String code;
  final String description;
  final double price;
  final bool isFeatured;
}
