import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:gap/gap.dart';

import '../managers/products_cubit/products_cubit.dart';

class ProductsEmptyState extends StatelessWidget {
  const ProductsEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 64.sp,
              color: context.colors.primary,
            ),
          ),
          Gap(20.h),
          Text(
            AppStrings.noProductsYet,
            style: AppTextStyles.font18Bold.copyWith(
              color: context.colors.mainText,
            ),
          ),
          Gap(8.h),
          Text(
            AppStrings.addFirstProduct,
            textAlign: TextAlign.center,
            style: AppTextStyles.font13Regular.copyWith(
              color: context.colors.subText,
            ),
          ),
          Gap(24.h),
          CustomMaterialButton(
            onPressed: () => context.pushNamed(
              Routes.productView,
              arguments: [context.read<ProductsCubit>()],
            ),
            text: AppStrings.addProduct,
            textStyle: AppTextStyles.font16Bold.copyWith(
              color: AppPalette.white,
            ),
          ),
        ],
      ),
    ),
  );
}
