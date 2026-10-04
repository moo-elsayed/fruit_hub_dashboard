import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/helpers/validator.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/text_form_field_helper.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/args/product_args.dart';

import 'custom_switch_container.dart';
import 'product_image_picker_card.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({super.key, required this.productArgs});

  final ProductArgs productArgs;

  @override
  Widget build(BuildContext context) => Column(
    spacing: 16.h,
    children: [
      ProductImagePickerCard(
        controller: productArgs.imageController,
        validator: Validator.validateRequiredField,
      ),
      TextFormFieldHelper(
        controller: productArgs.nameController,
        labelText: AppStrings.productName,
        keyboardType: TextInputType.name,
        onValidate: Validator.validateName,
        action: TextInputAction.next,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.w,
        children: [
          Expanded(
            child: TextFormFieldHelper(
              controller: productArgs.priceController,
              labelText: AppStrings.price,
              suffixText: AppStrings.pounds,
              suffixStyle: AppTextStyles.font13Medium.copyWith(
                color: context.colors.subText,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onValidate: Validator.validateRequiredField,
              action: TextInputAction.next,
            ),
          ),
          Expanded(
            child: TextFormFieldHelper(
              controller: productArgs.weightInGramsController,
              labelText: AppStrings.weightInGrams,
              suffixText: AppStrings.gram,
              suffixStyle: AppTextStyles.font12Medium.copyWith(
                color: context.colors.subText,
              ),
              keyboardType: TextInputType.number,
              onValidate: Validator.validateRequiredField,
              action: TextInputAction.next,
            ),
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.w,
        children: [
          Expanded(
            child: TextFormFieldHelper(
              controller: productArgs.codeController,
              labelText: AppStrings.productCode,
              keyboardType: TextInputType.number,
              readOnly: productArgs.isEditMode,
              fillColor: productArgs.isEditMode
                  ? context.colors.border.withValues(alpha: 0.25)
                  : null,
              suffixWidget: productArgs.isEditMode
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 18.sp,
                        color: context.colors.subText,
                      ),
                    )
                  : null,
              onValidate: Validator.validateCode,
              action: TextInputAction.next,
            ),
          ),
          Expanded(
            child: TextFormFieldHelper(
              controller: productArgs.daysUntilExpirationController,
              labelText: AppStrings.daysUntilExpiration,
              suffixText: AppStrings.days,
              suffixStyle: AppTextStyles.font12Medium.copyWith(
                color: context.colors.subText,
              ),
              keyboardType: TextInputType.number,
              onValidate: Validator.validateRequiredField,
              action: TextInputAction.next,
            ),
          ),
        ],
      ),
      TextFormFieldHelper(
        controller: productArgs.caloriesController,
        labelText: AppStrings.numberOfCalories,
        suffixText: AppStrings.calories,
        suffixStyle: AppTextStyles.font12Medium.copyWith(
          color: context.colors.subText,
        ),
        keyboardType: TextInputType.number,
        onValidate: Validator.validateRequiredField,
        action: TextInputAction.next,
      ),
      TextFormFieldHelper(
        controller: productArgs.descriptionController,
        labelText: AppStrings.productDescription,
        keyboardType: TextInputType.multiline,
        onValidate: Validator.validateDescription,
        maxLines: 4,
        minLines: 4,
        action: TextInputAction.done,
      ),
      Row(
        spacing: 12.w,
        children: [
          Expanded(
            child: CustomSwitchContainer(
              isChecked: productArgs.isOrganic,
              icon: Icons.eco_rounded,
              onChanged: (value) => productArgs.isOrganic = value,
              text: AppStrings.organic,
            ),
          ),
          Expanded(
            child: CustomSwitchContainer(
              isChecked: productArgs.isFeatured,
              icon: Icons.star_rounded,
              onChanged: (value) => productArgs.isFeatured = value,
              text: AppStrings.featured,
            ),
          ),
        ],
      ),
    ],
  );
}
