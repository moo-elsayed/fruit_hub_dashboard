import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/fruit_entity.dart';
import 'custom_product_item.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({
    super.key,
    this.fruits,
    this.itemCount,
    this.fromFavorite = false,
  });

  final List<FruitEntity>? fruits;
  final int? itemCount;
  final bool fromFavorite;

  @override
  Widget build(BuildContext context) => GridView.builder(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: itemCount ?? fruits?.length ?? 0,
      gridDelegate: buildSliverGridDelegateWithFixedCrossAxisCount(),
      itemBuilder: (context, index) {
        final fruitEntity = itemCount != null
            ? const FruitEntity()
            : fruits![index];
        return CustomProductItem(
          key: fromFavorite ? ValueKey(fruitEntity.code) : null,
          fruitEntity: fruitEntity,
        );
      },
    );

  SliverGridDelegateWithFixedCrossAxisCount
  buildSliverGridDelegateWithFixedCrossAxisCount() => SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 163 / 214,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
    );
}
