import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';
import 'package:gap/gap.dart';

class OrderItemsPreviewBar extends StatelessWidget {
  const OrderItemsPreviewBar({
    super.key,
    required this.products,
    required this.isExpanded,
    required this.onToggle,
  });

  final List<OrderItemEntity> products;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onToggle,
    borderRadius: BorderRadius.circular(8.r),
    child: Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _ProductsAvatarStack(products: products),
              Gap(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: context.colors.subText.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${products.length} ${AppStrings.items}',
                  style: AppTextStyles.font11SemiBold.copyWith(
                    color: context.colors.subText,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                isExpanded ? AppStrings.hideDetails : AppStrings.viewDetails,
                style: AppTextStyles.font12Medium.copyWith(
                  color: context.colors.primary,
                ),
              ),
              Gap(4.w),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.sp,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ProductsAvatarStack extends StatelessWidget {
  const _ProductsAvatarStack({required this.products});

  final List<OrderItemEntity> products;

  @override
  Widget build(BuildContext context) {
    final previewProducts = products.take(3).toList();
    if (previewProducts.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < previewProducts.length; i++)
          Align(
            widthFactor: i == 0 ? 1.0 : 0.75,
            child: Container(
              width: 26.r,
              height: 26.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.surface, width: 1.5),
              ),
              child: ClipOval(
                child: CustomNetworkImage(image: previewProducts[i].imagePath),
              ),
            ),
          ),
      ],
    );
  }
}
