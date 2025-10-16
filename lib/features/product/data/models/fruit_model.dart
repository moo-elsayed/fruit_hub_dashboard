import 'package:fruit_hub_dashboard/features/product/data/models/review_model.dart';
import '../../domain/entities/fruit_entity.dart';

class FruitModel extends FruitEntity {
  FruitModel({
    super.name,
    super.description,
    super.price,
    super.imagePath,
    super.code,
    super.isFeatured,
    super.avgRating,
    super.ratingCount,
    super.isOrganic,
    super.monthsUntilExpiration,
    super.unitAmount,
    super.numberOfCalories,
    super.reviews,
  });

  factory FruitModel.fromJson(Map<String, dynamic> json) => FruitModel(
    name: json['name'],
    description: json['description'],
    price: json['price'],
    imagePath: json['imagePath'],
    code: json['code'],
    isFeatured: json['isFeatured'],
    avgRating: json['avgRating'],
    ratingCount: json['ratingCount'],
    isOrganic: json['isOrganic'],
    monthsUntilExpiration: json['monthsUntilExpiration'],
    unitAmount: json['unitAmount'],
    numberOfCalories: json['numberOfCalories'],
    reviews: json['reviews'],
  );

  factory FruitModel.fromEntity(FruitEntity fruitEntity) => FruitModel(
    name: fruitEntity.name,
    description: fruitEntity.description,
    price: fruitEntity.price,
    imagePath: fruitEntity.imagePath,
    code: fruitEntity.code,
    isFeatured: fruitEntity.isFeatured,
    avgRating: fruitEntity.avgRating,
    ratingCount: fruitEntity.ratingCount,
    isOrganic: fruitEntity.isOrganic,
    monthsUntilExpiration: fruitEntity.monthsUntilExpiration,
    unitAmount: fruitEntity.unitAmount,
    numberOfCalories: fruitEntity.numberOfCalories,
    reviews: fruitEntity.reviews
        .map((review) => ReviewModel.fromEntity(review))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'imagePath': imagePath,
    'code': code,
    'isFeatured': isFeatured,
    'avgRating': avgRating,
    'ratingCount': ratingCount,
    'isOrganic': isOrganic,
    'monthsUntilExpiration': monthsUntilExpiration,
    'unitAmount': unitAmount,
    'numberOfCalories': numberOfCalories,
    'reviews': reviews
        .map((review) => ReviewModel.fromEntity(review).toJson())
        .toList(),
  };
}
