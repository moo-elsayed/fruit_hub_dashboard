import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/args/product_args.dart';
import 'package:gap/gap.dart';
import '../../../../core/helpers/validator.dart';
import '../../../../core/theming/app_palette.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../../../core/widgets/text_form_field_helper.dart';
import '../managers/pick_image_cubit/pick_image_cubit.dart';
import '../managers/products_cubit/products_cubit.dart';
import 'custom_product_image.dart';
import 'custom_switch_container.dart';

class ProductViewBody extends StatefulWidget {
  const ProductViewBody({
    super.key,
    required this.productArgs,
    this.imagePath = '',
  });

  final ProductArgs productArgs;
  final String imagePath;

  @override
  State<ProductViewBody> createState() => _ProductViewBodyState();
}

class _ProductViewBodyState extends State<ProductViewBody> {
  late bool _showMyImage = widget.imagePath != '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      behavior: .opaque,
      child: SingleChildScrollView(
        padding: .symmetric(horizontal: 16.w),
        child: Form(
          key: widget.productArgs.formKey,
          child: Column(
            children: [
              Gap(24.h),
              CustomProductImage(
                onImageSelected: (value) => widget.productArgs.image = value,
                onShowMyImageChanged: (value) => _showMyImage = value,
                imagePath: widget.imagePath,
                size: size,
              ),
              Gap(24.h),
              TextFormFieldHelper(
                controller: widget.productArgs.nameController,
                labelText: 'name',
                keyboardType: TextInputType.name,
                onValidate: Validator.validateName,
                action: TextInputAction.next,
              ),
              Gap(16.h),
              TextFormFieldHelper(
                controller: widget.productArgs.priceController,
                labelText: 'price',
                keyboardType: TextInputType.number,
                onValidate: Validator.validateRequiredField,
                action: TextInputAction.next,
              ),
              Gap(16.h),
              TextFormFieldHelper(
                controller: widget.productArgs.descriptionController,
                labelText: 'description',
                keyboardType: TextInputType.name,
                onValidate: Validator.validateDescription,
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
                      controller:
                          widget.productArgs.daysUntilExpirationController,
                      labelText: 'days until expiration',
                      keyboardType: TextInputType.number,
                      onValidate: Validator.validateRequiredField,
                      action: TextInputAction.next,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: widget.productArgs.codeController,
                      labelText: 'code',
                      keyboardType: TextInputType.number,
                      onValidate: Validator.validateCode,
                      action: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.w,
                children: [
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: widget.productArgs.caloriesController,
                      labelText: 'number of calories',
                      keyboardType: TextInputType.number,
                      onValidate: Validator.validateRequiredField,
                      action: TextInputAction.next,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: widget.productArgs.unitAmountController,
                      labelText: 'unit amount per gram',
                      keyboardType: TextInputType.number,
                      onValidate: Validator.validateRequiredField,
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
                      isChecked: widget.productArgs.isOrganic,
                      onChanged: (value) =>
                          widget.productArgs.isOrganic = value,
                      text: 'Organic',
                    ),
                  ),
                  Expanded(
                    child: CustomSwitchContainer(
                      isChecked: widget.productArgs.isFeatured,
                      onChanged: (value) =>
                          widget.productArgs.isFeatured = value,
                      text: 'Featured',
                    ),
                  ),
                ],
              ),
              Gap(30.h),
              BlocBuilder<ProductsCubit, ProductsState>(
                buildWhen: (previous, current) =>
                    current is ProductsLoading &&
                    (current.newItemAdded || current.itemUpdated),
                builder: (context, state) => CustomMaterialButton(
                  onPressed: () {
                    if (widget.productArgs.isValid &&
                        (widget.productArgs.image != null || _showMyImage)) {
                      if (widget.imagePath != '') {
                        context.read<ProductsCubit>().updateProduct(
                          widget.productArgs.toEntity(),
                        );
                      } else {
                        context.read<ProductsCubit>().addProduct(
                          widget.productArgs.toEntity(),
                        );
                      }
                    }
                    if (widget.productArgs.image == null &&
                        _showMyImage == false) {
                      context.read<PickImageCubit>().imageNotPicked();
                    }
                  },
                  isLoading:
                      state is ProductsLoading &&
                      (state.newItemAdded || state.itemUpdated),
                  maxWidth: true,
                  text: widget.imagePath != '' ? 'Edit Product' : 'Add Product',
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
}
