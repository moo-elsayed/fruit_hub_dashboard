import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/image_picker_field.dart';

import 'product_image_picker_empty_card.dart';
import 'product_image_picker_filled_card.dart';

class ProductImagePickerCard extends StatelessWidget {
  const ProductImagePickerCard({
    super.key,
    required this.controller,
    this.validator,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => FormField<String>(
    validator: (value) => validator?.call(
      controller.text.trim().isNotEmpty ? controller.text.trim() : value,
    ),
    initialValue: controller.text,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<String> state) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final hasImage = value.text.trim().isNotEmpty;

            if (hasImage) {
              return ProductImagePickerFilledCard(
                imagePath: value.text.trim(),
                hasError: state.hasError,
                onEdit: () => ImagePickerField.showPicker(
                  context: context,
                  controller: controller,
                  state: state,
                ),
                onDelete: () {
                  controller.clear();
                  state.didChange('');
                },
              );
            }

            return ProductImagePickerEmptyCard(
              hasError: state.hasError,
              onTap: () => ImagePickerField.showPicker(
                context: context,
                controller: controller,
                state: state,
              ),
            );
          },
        ),
        if (state.hasError)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 12.w, right: 12.w),
            child: Text(
              state.errorText!,
              style: AppTextStyles.font12Regular.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
      ],
    ),
  );
}
