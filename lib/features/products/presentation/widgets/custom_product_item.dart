import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/utils/full_screen_image_gallery_input_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_confirmation_dialog.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';
import 'package:fruit_hub_dashboard/core/widgets/edit_delete_action_buttons.dart';
import 'package:fruit_hub_dashboard/core/widgets/price_per_kilo.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_badge.dart';
import 'package:gap/gap.dart';

import '../../domain/entities/fruit_entity.dart';

class CustomProductItem extends StatelessWidget {
  const CustomProductItem({super.key, required this.fruitEntity});

  final FruitEntity fruitEntity;

  void _navigateToEdit(BuildContext context) => context.pushNamed(
    Routes.productView,
    arguments: [context.read<ProductsCubit>(), fruitEntity],
  );

  void _openImageGallery(BuildContext context) {
    if (fruitEntity.imagePath.isNotEmpty) {
      context.pushNamed(
        Routes.fullScreenImageView,
        arguments: FullScreenImageGalleryInputItem(
          imagesPaths: [fruitEntity.imagePath],
        ),
      );
    }
  }

  void _showDeleteDialog(BuildContext context) => CustomConfirmationDialog.show(
    context: context,
    title: AppStrings.deleteProduct,
    subtitle: AppStrings.deleteProductConfirmation,
    textConfirmButton: AppStrings.yes,
    textCancelButton: AppStrings.no,
    onConfirm: () {
      context.read<ProductsCubit>().deleteProduct(fruitEntity.code);
      context.pop();
    },
  );

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: context.colors.surface,
          border: Border.all(color: context.colors.border, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => _openImageGallery(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child:
                          fruitEntity.imagePath.isNotEmpty &&
                              fruitEntity.code.isNotEmpty
                          ? Hero(
                              tag: fruitEntity.imagePath,
                              child: CustomNetworkImage(
                                image: fruitEntity.imagePath,
                              ),
                            )
                          : CustomNetworkImage(image: fruitEntity.imagePath),
                    ),
                  ),
                ),
              ),
              Gap(8.h),
              Text(
                fruitEntity.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font14Bold.copyWith(
                  color: context.colors.mainText,
                ),
              ),
              Gap(2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: PricePerKilo(price: fruitEntity.price)),
                  EditDeleteActionButtons(
                    onEdit: () => _navigateToEdit(context),
                    onDelete: () => _showDeleteDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      if (fruitEntity.isOrganic)
        PositionedDirectional(
          top: 8.h,
          start: 8.w,
          child: ProductBadge(
            icon: Icons.eco_rounded,
            color: context.colors.primary,
            tooltip: AppStrings.organic,
          ),
        ),
      if (fruitEntity.isFeatured)
        PositionedDirectional(
          top: 8.h,
          end: 8.w,
          child: ProductBadge(
            icon: Icons.star_rounded,
            color: context.colors.secondary,
            tooltip: AppStrings.featured,
          ),
        ),
    ],
  );
}
