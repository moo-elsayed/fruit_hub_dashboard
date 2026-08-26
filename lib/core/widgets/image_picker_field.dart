import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/utils/full_screen_image_gallery_input_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/edit_delete_action_buttons.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatelessWidget {
  const ImagePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  Widget _buildThumbnail(BuildContext context, String path) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: 64.w,
        height: 64.w,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Container(width: 64.w, height: 64.w, color: context.colors.border),
        errorWidget: (context, url, error) => Icon(
          Icons.broken_image_rounded,
          size: 24.sp,
          color: context.colors.subText,
        ),
      );
    }
    return Image.file(
      File(path),
      width: 64.w,
      height: 64.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.broken_image_rounded,
        size: 24.sp,
        color: context.colors.subText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => FormField<String>(
    validator: validator,
    initialValue: controller.text,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<String> state) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, value, _) {
            final hasImage = controller.text.isNotEmpty;
            final borderColor = state.hasError
                ? context.colors.error
                : hasImage
                ? context.colors.primary.withValues(alpha: 0.3)
                : context.colors.border;

            return Container(
              padding: hasImage
                  ? EdgeInsets.all(8.w)
                  : EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: borderColor,
                  width: hasImage || state.hasError ? 1.5 : 1,
                ),
              ),
              child: hasImage
                  ? Row(
                      key: const ValueKey('filled'),
                      children: [
                        GestureDetector(
                          onTap: () => context.pushNamed(
                            Routes.fullScreenImageView,
                            arguments: FullScreenImageGalleryInputItem(
                              initialIndex: 0,
                              imagesPaths: [controller.text],
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Hero(
                                tag: controller.text,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: _buildThumbnail(
                                    context,
                                    controller.text,
                                  ),
                                ),
                              ),
                              Container(
                                width: 64.w,
                                height: 64.w,
                                decoration: BoxDecoration(
                                  color: AppPalette.black.withValues(
                                    alpha: 0.25,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.visibility_rounded,
                                  color: AppPalette.white,
                                  size: 22.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.text.split(RegExp(r'[/\\]')).last,
                                style: AppTextStyles.font13SemiBold.copyWith(
                                  color: context.colors.mainText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(4.h),
                              Text(
                                label,
                                style: AppTextStyles.font11Regular.copyWith(
                                  color: context.colors.subText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        EditDeleteActionButtons(
                          onEdit: () async {
                            try {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 85,
                                maxWidth: 1024,
                                maxHeight: 1024,
                              );
                              if (image != null) {
                                controller.text = image.path;
                                state.didChange(image.path);
                              }
                            } catch (_) {}
                          },
                          onDelete: () {
                            controller.clear();
                            state.didChange('');
                          },
                        ),
                      ],
                    )
                  : GestureDetector(
                      key: const ValueKey('empty'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        try {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                            maxWidth: 1024,
                            maxHeight: 1024,
                          );
                          if (image != null) {
                            controller.text = image.path;
                            state.didChange(image.path);
                          }
                        } catch (_) {}
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: context.colors.primary,
                              size: 22.sp,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Text(
                              label,
                              style: AppTextStyles.font14Medium.copyWith(
                                color: context.colors.mainText,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: context.colors.primary,
                            size: 22.sp,
                          ),
                        ],
                      ),
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
