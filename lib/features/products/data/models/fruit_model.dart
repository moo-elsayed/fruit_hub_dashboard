import 'package:fruit_hub_dashboard/features/products/data/models/review_model.dart';

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
    daysUntilExpiration: json['daysUntilExpiration'],
    unitAmount: json['unitAmount'],
    numberOfCalories: json['numberOfCalories'],
    reviews: json['reviews']
        .map<ReviewModel>((reviewJson) => ReviewModel.fromJson(reviewJson))
        .toList(),
    sellingCount: json['sellingCount'],
  );

  factory FruitModel.fromEntity(FruitEntity entity) => FruitModel(
    name: entity.name,
    description: entity.description,
    price: entity.price,
    imagePath: entity.imagePath,
    code: entity.code,
    isFeatured: entity.isFeatured,
    avgRating: entity.avgRating,
    ratingCount: entity.ratingCount,
    isOrganic: entity.isOrganic,
    daysUntilExpiration: entity.daysUntilExpiration,
    unitAmount: entity.unitAmount,
    numberOfCalories: entity.numberOfCalories,
    reviews: entity.reviews
        .map((review) => ReviewModel.fromEntity(review))
        .toList(),
    sellingCount: 0,
  );

  final String imagePath;
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
    'reviews': reviews.map((review) => review.toJson()).toList(),
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

  FruitModel copyWith({
    String? imagePath,
    String? name,
    String? code,
    String? description,
    double? price,
    bool? isFeatured,
    bool? isOrganic,
    int? daysUntilExpiration,
    int? numberOfCalories,
    int? unitAmount,
    int? ratingCount,
    int? sellingCount,
    num? avgRating,
    List<ReviewModel>? reviews,
  }) => FruitModel(
    imagePath: imagePath ?? this.imagePath,
    name: name ?? this.name,
    code: code ?? this.code,
    description: description ?? this.description,
    price: price ?? this.price,
    isFeatured: isFeatured ?? this.isFeatured,
    isOrganic: isOrganic ?? this.isOrganic,
    daysUntilExpiration: daysUntilExpiration ?? this.daysUntilExpiration,
    numberOfCalories: numberOfCalories ?? this.numberOfCalories,
    unitAmount: unitAmount ?? this.unitAmount,
    ratingCount: ratingCount ?? this.ratingCount,
    sellingCount: sellingCount ?? this.sellingCount,
    avgRating: avgRating ?? this.avgRating,
    reviews: reviews ?? this.reviews,
  );
}
