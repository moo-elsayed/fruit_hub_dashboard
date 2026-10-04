import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

class ProductImageDisplay extends StatelessWidget {
  const ProductImageDisplay({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.contain,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => imagePath.startsWith('http')
      ? CachedNetworkImage(
          imageUrl: imagePath,
          fit: fit,
          width: width,
          height: height,
          placeholder: (context, url) => ColoredBox(
            color: context.colors.border.withValues(alpha: 0.15),
            child: const Center(child: CupertinoActivityIndicator()),
          ),
          errorWidget: (context, url, error) => ColoredBox(
            color: context.colors.border.withValues(alpha: 0.15),
            child: Center(
              child: Icon(
                Icons.broken_image_rounded,
                size: 36.sp,
                color: context.colors.subText,
              ),
            ),
          ),
        )
      : Image.file(
          File(imagePath),
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => ColoredBox(
            color: context.colors.border.withValues(alpha: 0.15),
            child: Center(
              child: Icon(
                Icons.broken_image_rounded,
                size: 36.sp,
                color: context.colors.subText,
              ),
            ),
          ),
        );
}
