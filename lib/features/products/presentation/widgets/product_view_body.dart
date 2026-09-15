import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/helpers/app_strings.dart';
import '../../../../core/theming/app_palette.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../../../../core/widgets/custom_keyboard_unfocus.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../args/product_args.dart';
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
            BlocConsumer<ProductsCubit, ProductsState>(
              listenWhen: (previous, current) => current is ProductsFailure,
              listener: (context, state) {
                if (state is ProductsFailure) {
                  AppToast.show(
                    context: context,
                    title: state.errorMessage,
                    type: ToastificationType.error,
                  );
                }
              },
              buildWhen: (previous, current) =>
                  current is ProductsLoading ||
                  current is ProductsSuccess ||
                  current is ProductsFailure,
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
