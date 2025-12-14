import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/theming/app_colors.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';
import 'package:gap/gap.dart';
import '../../../../core/helpers/extentions.dart';
import '../../domain/entities/order_entity.dart';

class CustomOrderItem extends StatelessWidget {
  const CustomOrderItem({super.key, required this.orderEntity});

  final OrderEntity orderEntity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: .circular(12.r)),
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: .symmetric(horizontal: 16.w, vertical: 8.h),
        visualDensity: .compact,
        shape: const Border(),
        leading: _buildLeadingIcon(),
        title: _buildHeader(),
        subtitle: _buildSubtitle(),
        trailing: _buildPriceBadge(),
        children: [
          const Divider(height: 1, thickness: 0.5),
          _buildCustomerDetails(),
          const Divider(height: 1, thickness: 0.5),
          _buildProductsList(),
          _buildFooterActions(),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon() {
    IconData icon;
    Color color;

    switch (orderEntity.paymentOption.type) {
      case .paypal:
        icon = Icons.paypal;
        color = AppColors.blue;
      case .card:
        icon = Icons.credit_card;
        color = AppColors.purple;
      case .cash:
        icon = Icons.attach_money;
        color = AppColors.green;
    }

    return Container(
      padding: .all(8.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: .circle,
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Order #${orderEntity.orderId}',
          style: AppTextStyles.font16color0C0D0DBold,
        ),
        Gap(10.w),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final status = orderEntity.status;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: status.containerColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: status.color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.name,
        style: AppTextStyles.font11color1B5E37semiBold.copyWith(
          color: status.color,
          fontWeight: FontWeight.bold,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 4.h,
        children: [
          _buildSubtitleItem(
            icon: Icons.calendar_today_outlined,
            title: _formatDate(orderEntity.date),
          ),
          _buildSubtitleItem(
            icon: Icons.person_outline,
            title: orderEntity.address.name.isNotEmpty
                ? orderEntity.address.name
                : 'Unknown User',
          ),
          _buildSubtitleItem(
            icon: Icons.shopping_bag_outlined,
            title: '${orderEntity.products.length} Items',
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    return date.length > 10 ? date.substring(0, 10) : date;
  }

  Row _buildSubtitleItem({required IconData icon, required String title}) {
    return Row(
      mainAxisSize: .min,
      spacing: 2.w,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.grey),
        Text(title, style: AppTextStyles.font12GreyRegular),
      ],
    );
  }

  Widget _buildPriceBadge() {
    final total = orderEntity.totalPrice;

    return Column(
      mainAxisAlignment: .center,
      spacing: 2.h,
      children: [
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: AppTextStyles.font13color2D9F5DSemiBold.copyWith(
            fontWeight: .bold,
          ),
        ),
        Text(
          orderEntity.paymentOption.type.name.toUpperCase(),
          style: AppTextStyles.font11color1B5E37semiBold,
        ),
      ],
    );
  }

  Widget _buildCustomerDetails() {
    final address = orderEntity.address;
    return Container(
      padding: .all(16.r),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "Shipping Address",
            style: AppTextStyles.font13color0C0D0DSemiBold.copyWith(
              fontWeight: .bold,
            ),
          ),
          Gap(5.h),
          Text(
            "${address.streetName}, ${address.buildingNumber}, ${address.city}",
            style: AppTextStyles.font13color949D9ESemiBold,
          ),
          Text(
            "Phone: ${address.phone}",
            style: AppTextStyles.font13color949D9ESemiBold,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderEntity.products.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        final product = orderEntity.products[index];
        return ListTile(
          dense: true,
          leading: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(borderRadius: .circular(8.r)),
            child: CustomNetworkImage(image: product.imagePath),
          ),
          title: Text(
            product.name,
            style: AppTextStyles.font13color0C0D0DSemiBold.copyWith(
              fontWeight: .bold,
            ),
          ),
          subtitle: Text(
            "Code: ${product.code}",
            style: AppTextStyles.font13color949D9ESemiBold,
          ),
          trailing: Text(
            "${product.quantity} x \$${product.price}",
            style: AppTextStyles.font13color2D9F5DSemiBold.copyWith(
              fontWeight: .bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooterActions() {
    return Padding(
      padding: .all(12.r),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.blue),
                Gap(4.w),
                Text(
                  "Update Status",
                  style: AppTextStyles.font13color2D9F5DSemiBold.copyWith(
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: Text(
              "Print Invoice",
              style: AppTextStyles.font13color949D9ESemiBold.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
