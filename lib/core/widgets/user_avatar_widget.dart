import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    this.imagePath,
    this.name,
    this.size = 50,
  });

  final String? imagePath;
  final String? name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.trim().isNotEmpty;

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.primary.withValues(alpha: 0.12),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: ClipOval(
        child: hasImage
            ? _AvatarImage(imagePath: imagePath!, size: size, name: name)
            : _AvatarFallback(name: name, size: size),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({
    required this.imagePath,
    required this.size,
    required this.name,
  });

  final String imagePath;
  final double size;
  final String? name;

  @override
  Widget build(BuildContext context) => imagePath.startsWith('http')
      ? CachedNetworkImage(
          imageUrl: imagePath,
          width: size.r,
          height: size.r,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: size.r,
            height: size.r,
            color: context.colors.primary.withValues(alpha: 0.12),
          ),
          errorWidget: (context, url, error) =>
              _AvatarFallback(name: name, size: size),
        )
      : Image.file(
          File(imagePath),
          width: size.r,
          height: size.r,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _AvatarFallback(name: name, size: size),
        );
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.name, required this.size});

  final String? name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmedName = name?.trim() ?? '';
    if (trimmedName.isNotEmpty) {
      return Center(
        child: Text(
          trimmedName[0].toUpperCase(),
          style: AppTextStyles.font18Bold.copyWith(
            fontSize: (size * 0.38).sp,
            color: context.colors.primary,
          ),
        ),
      );
    }

    return Center(
      child: Icon(
        Icons.person_rounded,
        size: (size * 0.52).sp,
        color: context.colors.primary,
      ),
    );
  }
}
