import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_action_button.dart';
import '../../../../core/widgets/custom_confirmation_dialog.dart';
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
          padding: .symmetric(vertical: 20.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: .circular(4.r),
            color: AppColors.colorF3F5F7,
          ),
          child: Column(
            mainAxisAlignment: .spaceBetween,
            spacing: 8.h,
            children: [
              Flexible(child: CustomNetworkImage(image: fruitEntity.imagePath)),
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .end,
                children: [
                  Column(
                    crossAxisAlignment: .start,
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
                      arguments: [context.read<ProductsCubit>(), fruitEntity],
                    ),
                    child: Icon(Icons.edit, color: AppColors.white, size: 20.r),
                  ),
                ],
              ),
            ],
          ),
        ),
        PositionedDirectional(
          start: 8.w,
          top: 8.h,
          child: GestureDetector(
            onTap: () => showCupertinoDialog(
              context: context,
              builder: (_) => CustomConfirmationDialog(
                title: 'Delete Product',
                subtitle: 'Are you sure you want to delete this product?',
                textConfirmButton: 'Yes',
                textCancelButton: 'No',
                onConfirm: () {
                  context
                      .read<ProductsCubit>()
                      .deleteProduct(fruitEntity.code);
                  context.pop();
                },
              ),
            ),
            child: Icon(Icons.delete, color: AppColors.red, size: 20.r),
          ),
        ),
      ],
    );
  }
}
