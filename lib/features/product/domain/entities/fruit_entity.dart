import 'package:fruit_hub_dashboard/features/product/domain/entities/review_entity.dart';
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
    this.isOrganic = false,
    this.monthsUntilExpiration = 0,
    this.numberOfCalories = 0,
    this.unitAmount = 0,
    this.ratingCount = 0,
    this.avgRating = 0,
    this.reviews = const [],
  });

  final XFile? image;
  String imagePath;
  final String name;
  final String code;
  final String description;
  final double price;
  final bool isFeatured;
  final bool isOrganic;
  final int monthsUntilExpiration;
  final int numberOfCalories;
  final int unitAmount;
  final int ratingCount;
  final num avgRating;
  final List<ReviewEntity> reviews;
}
