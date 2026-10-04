import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/utils/full_screen_image_gallery_input_item.dart';

import 'product_action_button.dart';
import 'product_image_display.dart';

class ProductImagePickerFilledCard extends StatelessWidget {
  const ProductImagePickerFilledCard({
    super.key,
    required this.imagePath,
    required this.onEdit,
    required this.onDelete,
    this.hasError = false,
  });

  final String imagePath;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool hasError;

  void _onImageTap(BuildContext context) {
    if (imagePath.trim().isNotEmpty) {
      context.pushNamed(
        Routes.fullScreenImageGalleryView,
        arguments: FullScreenImageGalleryInputItem(
          initialIndex: 0,
          imagesPaths: [imagePath],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    height: 160.h,
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: hasError ? context.colors.error : context.colors.border,
        width: hasError ? 1.5 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppPalette.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 24,
            sigmaY: 24,
            tileMode: TileMode.clamp,
          ),
          child: Transform.scale(
            scale: 1.25,
            child: Opacity(
              opacity: 0.2,
              child: ProductImageDisplay(
                imagePath: imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _onImageTap(context),
          behavior: HitTestBehavior.opaque,
          child: Hero(
            tag: imagePath.trim(),
            child: ProductImageDisplay(
              imagePath: imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        PositionedDirectional(
          top: 10.h,
          end: 10.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              ProductActionButton(
                icon: Icons.camera_alt_rounded,
                iconColor: context.colors.primary,
                onTap: onEdit,
              ),
              ProductActionButton.delete(
                onTap: onDelete,
                isCircle: true,
                backgroundColor: context.colors.surface,
                borderColor: context.colors.surface,
                padding: EdgeInsets.all(7.r),
                hasShadow: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
