import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_action_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/price_per_kilo.dart';
import '../../domain/entities/fruit_entity.dart';

class CustomProductItem extends StatelessWidget {
  const CustomProductItem({super.key, required this.fruitEntity});

  final FruitEntity fruitEntity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: 20.h,
            horizontal: 10.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.circular(4.r),
            color: AppColors.colorF3F5F7,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8.h,
            children: [
              Flexible(child: CustomNetworkImage(image: fruitEntity.imagePath)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4.h,
                    children: [
                      Text(
                        fruitEntity.name,
                        style: AppTextStyles.font13color0C0D0DSemiBold,
                      ),
                      PricePerKilo(price: fruitEntity.price),
                    ],
                  ),
                  CustomActionButton(
                    onTap: () => context.pushNamed(
                      Routes.productView,
                      arguments: fruitEntity,
                    ),
                    child: Icon(Icons.edit, color: AppColors.white, size: 20.r),
                  ),
                ],
              ),
            ],
          ),
        ),
        BlocListener<ProductsCubit, ProductsState>(
          listener: (context, state) {},
          child: PositionedDirectional(
            start: 8.w,
            top: 8.h,
            child: GestureDetector(
              onTap: () {
                // delete
              },
              child: Icon(
                Icons.delete,
                color: AppColors.colorF4A91F,
                size: 20.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
