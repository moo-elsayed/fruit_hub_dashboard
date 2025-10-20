import 'package:fruit_hub_dashboard/features/product/data/models/review_model.dart';
import '../../domain/entities/fruit_entity.dart';

class FruitModel {
  FruitModel({
    required this.sellingCount,
    required this.reviews,
    required this.avgRating,
    required this.ratingCount,
    required this.isOrganic,
    required this.daysUntilExpiration,
    required this.unitAmount,
    required this.numberOfCalories,
    required this.imagePath,
    required this.code,
    required this.isFeatured,
    required this.description,
    required this.price,
    required this.name,
  });

  String imagePath;
  final String name;
  final String code;
  final String description;
  final double price;
  final bool isFeatured;
  final bool isOrganic;
  final int daysUntilExpiration;
  final int numberOfCalories;
  final int unitAmount;
  final int ratingCount;
  final int sellingCount;
  final num avgRating;
  final List<ReviewModel> reviews;

  factory FruitModel.fromJson(Map<String, dynamic> json) => FruitModel(
    name: json['name'],
    description: json['description'],
    price: json['price'],
    imagePath: json['imagePath'],
    code: json['code'],
    isFeatured: json['isFeatured'],
    avgRating: json['avgRating'] ?? 0,
    ratingCount: json['ratingCount'] ?? 0,
    isOrganic: json['isOrganic'],
    daysUntilExpiration: json['monthsUntilExpiration'],
    unitAmount: json['unitAmount'],
    numberOfCalories: json['numberOfCalories'],
    reviews: json['reviews']
        .map<ReviewModel>((reviewJson) => ReviewModel.fromJson(reviewJson))
        .toList(),
    sellingCount: json['sellingCount'],
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
    daysUntilExpiration: fruitEntity.daysUntilExpiration,
    unitAmount: fruitEntity.unitAmount,
    numberOfCalories: fruitEntity.numberOfCalories,
    reviews: fruitEntity.reviews
        .map((review) => ReviewModel.fromEntity(review))
        .toList(),
    sellingCount: 0,
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
    'daysUntilExpiration': daysUntilExpiration,
    'unitAmount': unitAmount,
    'numberOfCalories': numberOfCalories,
    'reviews': reviews
        .map((review) => ReviewModel.fromEntity(review.toEntity()).toJson())
        .toList(),
    'sellingCount': sellingCount,
  };

  FruitEntity toEntity() => FruitEntity(
    name: name,
    description: description,
    price: price,
    imagePath: imagePath,
    code: code,
    isFeatured: isFeatured,
    avgRating: avgRating,
    ratingCount: ratingCount,
    isOrganic: isOrganic,
    daysUntilExpiration: daysUntilExpiration,
    unitAmount: unitAmount,
    numberOfCalories: numberOfCalories,
    reviews: reviews.map((review) => review.toEntity()).toList(),
  );
}
