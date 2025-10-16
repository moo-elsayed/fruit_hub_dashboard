import 'package:fruit_hub_dashboard/features/product/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    super.name,
    super.description,
    super.rating,
    super.date,
    super.image,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['name'],
      description: json['description'],
      rating: json['rating'],
      date: json['date'],
      image: json['image'],
    );
  }

  factory ReviewModel.fromEntity(ReviewEntity reviewEntity) => ReviewModel(
    name: reviewEntity.name,
    description: reviewEntity.description,
    rating: reviewEntity.rating,
    date: reviewEntity.date,
    image: reviewEntity.image,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'rating': rating,
      'date': date,
      'image': image,
    };
  }
}
