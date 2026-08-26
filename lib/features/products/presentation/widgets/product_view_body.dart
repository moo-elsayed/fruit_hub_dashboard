import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/args/product_args.dart';
import 'package:gap/gap.dart';
import '../managers/products_cubit/products_cubit.dart';
import 'product_form_fields.dart';

class ProductViewBody extends StatelessWidget {
  const ProductViewBody({
    super.key,
    required this.productArgs,
    this.isEdit = false,
  });

  final ProductArgs productArgs;
  final bool isEdit;

  void _handleSubmit(BuildContext context) {
    if (productArgs.isValid) {
      final entity = productArgs.toEntity();
      if (isEdit) {
        context.read<ProductsCubit>().updateProduct(entity);
      } else {
        context.read<ProductsCubit>().addProduct(entity);
      }
    }
  }

  @override
  Widget build(BuildContext context) => CustomKeyboardUnfocus(
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: productArgs.formKey,
        child: Column(
          children: [
            Gap(20.h),
            ProductFormFields(productArgs: productArgs),
            Gap(28.h),
            BlocBuilder<ProductsCubit, ProductsState>(
              buildWhen: (previous, current) =>
                  current is ProductsLoading &&
                  (current.newItemAdded || current.itemUpdated),
              builder: (context, state) => CustomMaterialButton(
                onPressed: () => _handleSubmit(context),
                isLoading:
                    state is ProductsLoading &&
                    (state.newItemAdded || state.itemUpdated),
                maxWidth: true,
                text: isEdit ? AppStrings.editProduct : AppStrings.addProduct,
                textStyle: AppTextStyles.font16Bold.copyWith(
                  color: AppPalette.white,
                ),
              ),
            ),
            Gap(24.h),
          ],
        ),
      ),
    ),
  );
}
