import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/args/product_args.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/helpers/validator.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../../../core/widgets/text_form_field_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../managers/products_cubit/products_cubit.dart';
import '../managers/pick_image_cubit/pick_image_cubit.dart';
import 'custom_product_image.dart';
import 'custom_switch_container.dart';

class ProductViewBody extends StatelessWidget {
  const ProductViewBody({
    super.key,
    required this.productArgs,
    required this.isEdit,
  });

  final ProductArgs productArgs;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: productArgs.formKey,
          child: Column(
            children: [
              Gap(24.h),
              CustomProductImage(
                onImageSelected: (value) => productArgs.image = value,
                size: size,
              ),
              Gap(24.h),
              TextFormFieldHelper(
                controller: productArgs.nameController,
                labelText: "name",
                keyboardType: TextInputType.name,
                onValidate: (value) => Validator.validateName(val: value),
                action: TextInputAction.next,
              ),
              Gap(16.h),
              TextFormFieldHelper(
                controller: productArgs.priceController,
                labelText: "price",
                keyboardType: TextInputType.number,
                onValidate: (value) =>
                    Validator.validateName(val: value, type: "Price"),
                action: TextInputAction.next,
              ),
              Gap(16.h),
              TextFormFieldHelper(
                controller: productArgs.descriptionController,
                labelText: "description",
                keyboardType: TextInputType.name,
                onValidate: (value) =>
                    Validator.validateName(val: value, type: "Description"),
                maxLines: 5,
                minLines: 5,
                action: TextInputAction.next,
              ),
              Gap(16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.w,
                children: [
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: productArgs.daysUntilExpirationController,
                      labelText: "days until expiration",
                      keyboardType: TextInputType.number,
                      onValidate: (value) => Validator.validateName(
                        val: value,
                        type: "days until expiration",
                      ),
                      action: TextInputAction.next,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: productArgs.codeController,
                      labelText: "code",
                      keyboardType: TextInputType.number,
                      onValidate: Validator.validateCode,
                      action: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                crossAxisAlignment: .start,
                spacing: 16.w,
                children: [
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: productArgs.caloriesController,
                      labelText: "number of calories",
                      keyboardType: TextInputType.number,
                      onValidate: (value) => Validator.validateName(
                        val: value,
                        type: "number of calories",
                      ),
                      action: TextInputAction.next,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: productArgs.unitAmountController,
                      labelText: "unit amount per gram",
                      keyboardType: TextInputType.number,
                      onValidate: (value) => Validator.validateName(
                        val: value,
                        type: "number of calories",
                      ),
                      action: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                spacing: 16.w,
                children: [
                  Expanded(
                    child: CustomSwitchContainer(
                      isChecked: productArgs.isOrganic,
                      onChanged: (value) => productArgs.isOrganic = value,
                      text: "Organic",
                    ),
                  ),
                  Expanded(
                    child: CustomSwitchContainer(
                      isChecked: productArgs.isFeatured,
                      onChanged: (value) => productArgs.isFeatured = value,
                      text: "Featured",
                    ),
                  ),
                ],
              ),
              Gap(30.h),
              BlocConsumer<ProductsCubit, ProductsState>(
                listener: (context, state) {
                  if (state is AddProductSuccess) {
                    AppToast.showToast(
                      context: context,
                      title: "Product Added Successfully",
                      type: ToastificationType.success,
                    );
                  } else if (state is AddProductFailure) {
                    AppToast.showToast(
                      context: context,
                      title: state.errorMessage,
                      type: ToastificationType.error,
                    );
                  }
                },
                builder: (context, state) {
                  return CustomMaterialButton(
                    onPressed: () {
                      if (productArgs.isValid) {
                        if (isEdit){
                          // context.read<ProductsCubit>().editProduct(
                          //   productArgs.toEntity(),
                          // );
                        }
                        else {
                          context.read<ProductsCubit>().addProduct(
                            productArgs.toEntity(),
                          );
                        }
                      }
                      if (productArgs.image == null) {
                        context.read<PickImageCubit>().imageNotPicked();
                      }
                    },
                    isLoading: state is AddProductLoading,
                    maxWidth: true,
                    text: isEdit ? "Edit Product" : "Add Product",
                    textStyle: AppTextStyles.font16WhiteBold,
                  );
                },
              ),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}
