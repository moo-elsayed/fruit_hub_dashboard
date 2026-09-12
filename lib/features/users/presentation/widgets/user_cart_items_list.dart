import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

import '../../domain/entities/cart_item_entity.dart';

class UserCartItemsList extends StatelessWidget {
  const UserCartItemsList({super.key, required this.cartItems});

  final List<CartItemEntity> cartItems;

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 36.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.h,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 40.sp,
                color: context.colors.subText,
              ),
              Text(
                AppStrings.emptyCart,
                style: AppTextStyles.font14Medium.copyWith(
                  color: context.colors.subText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppPalette.secondaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 20.sp,
                  color: AppPalette.secondaryOrange,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.h,
                  children: [
                    Text(
                      '${AppStrings.productCode}: ${item.productId}',
                      style: AppTextStyles.font13SemiBold.copyWith(
                        color: context.colors.mainText,
                      ),
                    ),
                    Text(
                      '${AppStrings.itemsCount}: ${item.quantity}',
                      style: AppTextStyles.font12Regular.copyWith(
                        color: context.colors.subText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'x${item.quantity}',
                  style: AppTextStyles.font13Bold.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
