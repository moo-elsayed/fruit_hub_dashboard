import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/helpers/validator.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/image_picker_field.dart';
import 'package:fruit_hub_dashboard/core/widgets/text_form_field_helper.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/args/product_args.dart';
import 'package:gap/gap.dart';
import 'custom_switch_container.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({super.key, required this.productArgs});

  final ProductArgs productArgs;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ImagePickerField(
        controller: productArgs.imageController,
        label: AppStrings.productImage,
        icon: Icons.add_photo_alternate_rounded,
        validator: Validator.validateRequiredField,
      ),
      Gap(16.h),
      TextFormFieldHelper(
        controller: productArgs.nameController,
        labelText: AppStrings.productName,
        keyboardType: TextInputType.name,
        onValidate: Validator.validateName,
        action: TextInputAction.next,
      ),
      Gap(16.h),
      TextFormFieldHelper(
        controller: productArgs.priceController,
        labelText: AppStrings.price,
        suffixText: AppStrings.pounds,
        suffixStyle: AppTextStyles.font13Medium.copyWith(
          color: context.colors.subText,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onValidate: Validator.validateRequiredField,
        action: TextInputAction.next,
      ),
      Gap(16.h),
      TextFormFieldHelper(
        controller: productArgs.descriptionController,
        labelText: AppStrings.productDescription,
        keyboardType: TextInputType.multiline,
        onValidate: Validator.validateDescription,
        maxLines: 4,
        minLines: 4,
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
        ],
      ),
      Gap(16.h),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.w,
        children: [
          Expanded(
            child: TextFormFieldHelper(
              controller: productArgs.caloriesController,
              labelText: AppStrings.numberOfCalories,
              hint: 'e.g. 52',
              suffixText: AppStrings.calories,
              suffixStyle: AppTextStyles.font12Medium.copyWith(
                color: context.colors.subText,
              ),
              keyboardType: TextInputType.number,
              onValidate: Validator.validateRequiredField,
              action: TextInputAction.next,
            ),
          ),
          Expanded(
            child: TextFormFieldHelper(
              controller: productArgs.unitAmountController,
              labelText: AppStrings.unitAmountPerGram,
              hint: '1000',
              suffixText: AppStrings.gram,
              suffixStyle: AppTextStyles.font12Medium.copyWith(
                color: context.colors.subText,
              ),
              keyboardType: TextInputType.number,
              onValidate: Validator.validateRequiredField,
              action: TextInputAction.done,
            ),
          ),
        ],
      ),
      Gap(16.h),
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
